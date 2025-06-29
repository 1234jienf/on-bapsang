import os
import re
import mysql.connector
from dotenv import load_dotenv
from openai import OpenAI
from pinecone import Pinecone
from upstage_chat_llm import UpstageChatLLM
from langchain.schema import HumanMessage
from functools import lru_cache

# 환경 변수 로드
load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

# 설정
DB_CONF = {
    "host": os.getenv("MYSQL_HOST", "localhost"),
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", ""),
    "database": os.getenv("MYSQL_DATABASE", "bapsang"),
    "charset": "utf8mb4"
}
UPSTAGE_API_TOKEN = os.getenv("UPSTAGE_API_TOKEN")
PINECONE_API_KEY = os.getenv("PINECONE_API_KEY")
PINECONE_INDEX = os.getenv("PINECONE_INDEX_NAME", "recipe-index")

# DB Connection Pool 생성
try:
    pool = mysql.connector.pooling.MySQLConnectionPool(
        pool_name="bapsang_pool",
        pool_size=10,
        pool_reset_session=True,
        **DB_CONF
    )
    print(f"✅ DB 커넥션 풀 생성: {DB_CONF['host']}:{DB_CONF.get('database')}")
except mysql.connector.Error as e:
    import sys, traceback
    print("❌ DB 커넥션 풀 생성 실패!", file=sys.stderr)
    traceback.print_exc()
    raise RuntimeError("DB 커넥션 풀 생성 실패. .env 환경설정 또는 DB 상태 확인 요망.")


# OpenAI / Pinecone 클라이언트
openai = OpenAI(api_key=UPSTAGE_API_TOKEN, base_url="https://api.upstage.ai/v1")
pc = Pinecone(api_key=PINECONE_API_KEY)
index = pc.Index(PINECONE_INDEX)

# 🌱 Embedding 생성 (LRU 캐시)
@lru_cache(maxsize=8192)
def get_embedding_cached(text: str) -> tuple:
    """food_name -> tuple(embedding)"""
    resp = openai.embeddings.create(input=text, model="embedding-query")
    return tuple(resp.data[0].embedding)


# 레시피 Bulk Fetch
def fetch_recipes_bulk(ids: list[str]) -> dict[str, dict]:
    if not ids:
        return {}

    # 매 요청마다 fresh 커넥션 확보
    conn = pool.get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            f"""SELECT r.recipe_id, r.name, r.description, r.review, r.time,
                      r.difficulty, r.portion, r.method, r.material_type, r.image_url,
                      rim.name AS ingredient
                 FROM recipe r
            LEFT JOIN recipe_ingredient ri  ON r.recipe_id = ri.recipe_id
            LEFT JOIN recipe_ingredient_master rim ON ri.ingredient_id = rim.ingredient_id
                WHERE r.recipe_id IN ({", ".join(['%s'] * len(ids))})""",
            ids
        )

        recipes: dict[str, dict] = {}
        for row in cursor.fetchall():
            (rid, name, desc, review, time, diff, portion,
             method, mat_type, img, ingr) = row

            rid = str(rid)
            rec = recipes.setdefault(rid, {
                "recipe_id": rid, "name": name, "ingredients": [],
                "description": desc, "review": review, "time": time,
                "difficulty": diff, "portion": portion, "method": method,
                "material_type": mat_type, "image_url": img
            })
            if ingr:
                rec["ingredients"].append(ingr)

        return recipes

    finally:
        cursor.close()
        conn.close()


# 추천 함수
def recommend(food_name: str, top_k: int = 100) -> dict:
    try:
        # 1) Embedding
        vec = get_embedding_cached(food_name)

        # 2) Pinecone Query
        pc_res = index.query(vector=vec, top_k=top_k, include_metadata=True)
        matches = pc_res["matches"]

        # 3) DB 한 번에 조회
        ids_scores = [(m["id"], m["score"]) for m in matches]
        recipes = fetch_recipes_bulk([rid for rid, _ in ids_scores])

        dishes = []
        for rid, score in ids_scores:
            if rid in recipes:
                rec = recipes[rid]
                rec["score"] = score
                dishes.append(rec)

        return {
            "food_name": food_name,
            "message": "추천이 완료되었습니다.",
            "recommended_dishes": dishes
        }

    except Exception as e:
        import traceback
        traceback.print_exc()
        return {
            "food_name": food_name,
            "message": f"추천 중 오류 발생: {str(e)}",
            "recommended_dishes": []
        }
