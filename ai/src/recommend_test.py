import os
import mysql.connector
from dotenv import load_dotenv
from openai import OpenAI
import json
import pinecone
from upstage_chat_llm import UpstageChatLLM
from langchain.schema import HumanMessage
import re
from pinecone import Pinecone, ServerlessSpec
from mysql.connector import pooling

# 환경변수 로드
dotenv_path = os.path.join(os.path.dirname(__file__), "..", "..", ".env")
load_dotenv(dotenv_path)

UPSTAGE_API_TOKEN = os.environ.get("UPSTAGE_API_TOKEN")
PINECONE_API_KEY = os.environ.get("PINECONE_API_KEY")  # Pinecone API Key 추가

# DB 연결 (메인)
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='bjh0112525',
    database='bapsang',
    charset='utf8mb4'
)
cursor = conn.cursor()

# Upstage Embedding 클라이언트 설정
client = OpenAI(api_key=UPSTAGE_API_TOKEN, base_url="https://api.upstage.ai/v1")

pc = Pinecone(api_key=PINECONE_API_KEY)

index_name = "recipe-index"
index = pc.Index(index_name)  

# Embedding을 생성하는 함수
def get_recipe_embedding(recipe_text):
    response = client.embeddings.create(
        input=recipe_text,
        model="embedding-query"
    )
    return response.data[0].embedding

# # 레시피 벡터화 및 Pinecone에 업로드
# cursor.execute("SELECT recipe_id, name FROM Recipe WHERE recipe_id >= 7040214")
# recipes = cursor.fetchall()

# # Pinecone에 벡터 업로드
# for recipe_id, name in recipes:
#     # 각 레시피의 재료 정보 가져오기 (RecipeIngredient 및 RecipeIngredientMaster 테이블에서)
#     cursor.execute("""
#         SELECT rim.name, ri.amount
#         FROM RecipeIngredient ri
#         JOIN RecipeIngredientMaster rim ON ri.ingredient_id = rim.ingredient_id
#         WHERE ri.recipe_id = %s
#     """, (recipe_id,))
#     ingredients = cursor.fetchall()
    
#     # 재료 텍스트 조합
#     ingredients_text = ', '.join([f"{ing_name} ({amount})" for ing_name, amount in ingredients])
    
#     # recipe_text 생성
#     recipe_text = f"{name} Ingredients: {ingredients_text}"
    
#     # Embedding 생성
#     recipe_vector = get_recipe_embedding(recipe_text)

#     # 기존에 데이터가 있는지 확인 (벡터로 검색)
#     query_results = index.query(vector=recipe_vector, top_k=1, include_metadata=True)

    
#     # 새 레시피만 업로드
#     print(f"Uploading recipe_id={recipe_id}, name={name}, ingredients={ingredients_text}")
#     index.upsert([(str(recipe_id), recipe_vector, {"name": name, "ingredients": ingredients_text})])

# 사용자 입력받기
foreign_dish = input("해외 음식 이름을 입력하세요: ")
foreign_dish_ingredients = input("해외 음식 재료를 입력하세요 (선택사항): ")

# 외국 음식 벡터화
foreign_dish_text = f"{foreign_dish} Ingredients: {foreign_dish_ingredients}"  # 설명은 제외하고 이름과 재료만 사용
foreign_dish_vector = get_recipe_embedding(foreign_dish_text)

# Pinecone에서 유사도 검색 (변경된 형식)
results = index.query(vector=foreign_dish_vector, top_k=5, include_metadata=True)
# 추천할 레시피 목록 만들기
recommended_recipes = []
for result in results['matches']:
    recipe_id = result['id']
    score = result['score']
    cursor.execute("SELECT name, description FROM Recipe WHERE recipe_id = %s", (recipe_id,))
    recipe_data = cursor.fetchone()
    if recipe_data:
        recommended_recipes.append({
            "name": recipe_data[0],
            "description": recipe_data[1],
            "score": score
        })

# 프롬프트 만들기
# prompt_text = f"""
# You are a professional Korean chef. You must choose **exactly 5** recipes from the provided list that are most similar or most appropriate to recommend for the foreign dish '{foreign_dish}'. 
# - **절대** 후보 리스트 외의 요리는 언급하지 마세요.

# - 1차 기준: 주재료 기반(면 vs 밥 등)
# - 2차 기준: 맛 프로파일(매운맛, 단맛, 신맛, 짭짤함, 감칠맛 등)
# - 추천 순위 이해를 돕기 위해 0부터 100까지의 유사도 점수(score)도 함께 제공하세요.
# \n\n

# 추천 레시피 리스트:
# """
prompt_text = f"""
You are a professional Korean chef. You must choose **exactly 5** Korean recipes from the provided list that are most similar or most appropriate to recommend for the foreign dish '{foreign_dish}'. 
- **절대** 후보 리스트 외의 요리는 언급하지 마세요.
\n\n

추천 레시피 리스트:
"""


for idx, rec in enumerate(recommended_recipes, start=1):
    prompt_text += f"{idx}. {rec['name']} - {rec['description']} (유사도 점수: {rec['score']})\n"

# Upstage LLM 준비
llm = UpstageChatLLM(api_token=UPSTAGE_API_TOKEN, model="solar-pro")

# AI 호출
print(" AI에게 추천 요청 중...")
response = llm.invoke([HumanMessage(content=prompt_text)])

# 응답 문자열 추출
content_str = response.content if hasattr(response, "content") else response

# ✅ 코드블럭 (```json ... ```) 제거 (있을 경우만)
content_str = re.sub(r"```json\s*([\s\S]*?)\s*```", r"\1", content_str).strip()

try:
    result = json.loads(content_str)
    recommendations = result.get("recommendations", [])

    if not recommendations:
        print("⚠ 추천 결과가 비어 있습니다.")
    else:
        print("✅ 추천 결과:")
        for idx, rec in enumerate(recommendations, start=1):
            rec_name = rec['name']
            reason = rec['reason']
            print(f"\n{idx}. {rec_name} - {reason}")

            # 레시피 기본 정보 조회
            cursor.execute("SELECT recipe_id, description, review FROM Recipe WHERE name = %s", (rec_name,))
            recipe_data = cursor.fetchone()

            if recipe_data:
                recipe_id, description, review = recipe_data
                print(f"   📖 설명: {description}")
                print(f"   📝 리뷰: {review}")

                # 재료까지 조회
                cursor.execute("""
                    SELECT rim.name, ri.amount
                    FROM RecipeIngredient ri
                    JOIN RecipeIngredientMaster rim ON ri.ingredient_id = rim.ingredient_id
                    WHERE ri.recipe_id = %s
                """, (recipe_id,))
                ingredients = cursor.fetchall()

                if ingredients:
                    print("   🧂 재료:")
                    for ing_name, amount in ingredients:
                        amount_display = amount if amount and amount.strip() else "수량 정보 없음"
                        print(f"     • {ing_name:<10}: {amount_display}")
            else:
                print("⚠ 해당 레시피가 DB에서 발견되지 않았습니다.")

except json.JSONDecodeError:
    print("⚠ AI 응답 파싱 실패, 원본 출력:")
    print(content_str)

# DB 연결 종료
conn.close()