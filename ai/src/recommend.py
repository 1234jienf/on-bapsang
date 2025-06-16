import os, re
import mysql.connector
from dotenv import load_dotenv
from openai import OpenAI
from pinecone import Pinecone
from upstage_chat_llm import UpstageChatLLM
from langchain.schema import HumanMessage
from functools import lru_cache  

# 환경변수 로드
load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

# 설정
DB_CONF = {
    "host":     os.getenv("MYSQL_HOST", "localhost"),
    "user":     os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", ""),
    "database": os.getenv("MYSQL_DATABASE", "bapsang"),
    "charset":  "utf8mb4"
}
UPSTAGE_API_TOKEN = os.getenv("UPSTAGE_API_TOKEN")
PINECONE_API_KEY   = os.getenv("PINECONE_API_KEY")
PINECONE_INDEX     = os.getenv("PINECONE_INDEX_NAME", "recipe-index")

# DB 커넥션 (모듈 레벨에서 한 번만)
conn   = mysql.connector.connect(**DB_CONF)
cursor = conn.cursor()

# OpenAI / Pinecone 클라이언트
openai = OpenAI(api_key=UPSTAGE_API_TOKEN, base_url="https://api.upstage.ai/v1")
pc     = Pinecone(api_key=PINECONE_API_KEY)
index  = pc.Index(PINECONE_INDEX)

# def get_embedding(text: str) -> list[float]:
#     resp = openai.embeddings.create(input=text, model="embedding-query")
#     return resp.data[0].embedding
# 기존 get_embedding 삭제/주석 처리
# def get_embedding(text): ...

@lru_cache(maxsize=8_192)               # ⬅︎ 메모리 LRU 캐시
def get_embedding_cached(text: str) -> tuple:
    """food_name → tuple(embedding)  # tuple 로 해야 hashable"""
    resp = openai.embeddings.create(input=text, model="embedding-query")
    return tuple(resp.data[0].embedding)


def fetch_recipes_bulk(ids: list[str]) -> dict[str, dict]:
    if not ids:
        return {}

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

        rid = str(rid)                    # ★ ID 를 문자열로 통일 ★
        rec = recipes.setdefault(rid, {
            "recipe_id": rid, "name": name, "ingredients": [],
            "descriptions": desc, "review": review, "time": time,
            "difficulty": diff, "portion": portion, "method": method,
            "material_type": mat_type, "image_url": img
        })
        if ingr:
            rec["ingredients"].append(ingr)
    return recipes



def recommend(food_name: str, top_k: int = 100) -> dict:
    # 1) Embedding
    vec = get_embedding_cached(food_name)

    # 2) Pinecone query
    pc_res = index.query(vector=vec, top_k=top_k, include_metadata=True)
    matches = pc_res["matches"]
    # 3) DB 한 번에
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
        "message":   "추천이 완료되었습니다.",
        "recommended_dishes": dishes
    }
