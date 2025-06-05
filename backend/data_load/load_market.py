import pandas as pd
import mysql.connector
import chardet
import json

# DB 연결
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='bjh0112525',
    database='bapsang',
    charset='utf8mb4'
)
cursor = conn.cursor()

# product_name 매핑 불러오기
with open('mapped_product_names.json', 'r', encoding='utf-8') as f:
    product_mapping = json.load(f)

# 인코딩 감지 함수
def detect_file_encoding(filepath):
    with open(filepath, 'rb') as f:
        raw_data = f.read(10000)
    result = chardet.detect(raw_data)
    encoding = result['encoding']
    if not encoding:
        print(f"⚠ Fallback encoding for {filepath}: cp949")
        encoding = 'cp949'
    return encoding

# MarketItem 존재 확인 및 삽입
def insert_market_item_if_not_exists(cursor, pdl_code, pdl_nm, spcs_code, spcs_nm):
    key = f"{pdl_nm}|||{spcs_nm}"
    mapping = product_mapping.get(key)
    
    if mapping:
        product_name = mapping.get("product_name", pdl_nm)
        detail = mapping.get("detail")
    else:
        product_name = pdl_nm
        detail = None

    cursor.execute("SELECT market_item_id FROM MarketItem WHERE pdl_code = %s AND spcs_code = %s", (pdl_code, spcs_code))
    result = cursor.fetchone()
    if not result:
        cursor.execute(
            "INSERT INTO MarketItem (pdl_code, pdl_nm, spcs_code, spcs_nm, product_name, detail) VALUES (%s, %s, %s, %s, %s, %s)",
            (pdl_code, pdl_nm, spcs_code, spcs_nm, product_name, detail)
        )
        conn.commit()

# MarketPrice 삽입
def insert_market_price(cursor, market_item_id, price_date, price, unit, grade,market_name):
    cursor.execute(
        """
        INSERT INTO MarketPrice (market_item_id, price_date, price, unit, grade, market_name)
        VALUES (%s, %s, %s, %s, %s, %s)
        """,
        (market_item_id, price_date, price, unit, grade, market_name)
    )
    conn.commit()

# Ingredient ↔ MarketItem 매핑 삽입
def find_and_insert_ingredient_market_mapping(cursor, ingredient_name, market_item_id):
    cursor.execute("SELECT ingredient_id FROM RecipeIngredientMaster WHERE name = %s", (ingredient_name,))
    result = cursor.fetchone()
    if result:
        ingredient_id = result[0]
    else:
        print(f"⚠ Ingredient '{ingredient_name}' not found in RecipeIngredientMaster")
        return

    cursor.execute("""
        SELECT * FROM IngredientMarketMapping 
        WHERE ingredient_id = %s AND market_item_id = %s
    """, (ingredient_id, market_item_id))
    if not cursor.fetchone():
        cursor.execute("""
            INSERT INTO IngredientMarketMapping (ingredient_id, market_item_id)
            VALUES (%s, %s)
        """, (ingredient_id, market_item_id))
        conn.commit()
        print(f"🔗 Mapped ingredient '{ingredient_name}' to market_item_id {market_item_id}")

# 파일 리스트
market_files = [
    # '../../data/raw_market/2024년 05월 농수축산물 일자별 도소매 가격-20240617.csv',
    # '../../data/raw_market/2024년 06월 농수축산물 일자별 도소매 가격-20240716.csv',
    # '../../data/raw_market/2024년 09월 농수축산물 일자별 도소매 가격-20241016.csv',
    '../../data/raw_market/2024년 10월 농수축산물 일자별 도소매 가격-20241115.csv',
]

for file in market_files:
    encoding = detect_file_encoding(file)
    df = pd.read_csv(file, encoding=encoding)
    print(f"✅ Loaded {file} with {len(df)} rows.")

    for _, row in df.iterrows():
        if row['MRKT_NM'] not in ['경동', '부전', '칠성', '현대', '양동', '남부']:
            continue
        if str(row['BULK_GRAD_NM']).strip() == '중품':
            continue
        
        price_date = str(row['PRCE_REG_YMD'])
        # 각 달의 1일 데이터만 선택
        if not price_date.endswith('02'):
            continue
        
        pdl_code = str(row['PDLT_CODE'])
        pdl_nm = str(row['PDLT_NM'])
        spcs_code = str(row['SPCS_CODE'])
        spcs_nm = str(row['SPCS_NM'])
        price = float(row['PDLT_PRCE'])
        unit = str(row['RTSL_SMT_UNIT_NM']) if pd.notnull(row['RTSL_SMT_UNIT_NM']) else ''
        grade = str(row['BULK_GRAD_NM']) if pd.notnull(row['BULK_GRAD_NM']) else ''
        market_name = str(row['MRKT_NM']) 

        insert_market_item_if_not_exists(cursor, pdl_code, pdl_nm, spcs_code, spcs_nm)

        cursor.execute("SELECT market_item_id FROM MarketItem WHERE pdl_code = %s AND spcs_code = %s", (pdl_code, spcs_code))
        market_item_id = cursor.fetchone()[0]

        insert_market_price(cursor, market_item_id, price_date, price, unit, grade, market_name)
        print(f"💰 Inserted price: {pdl_nm}-{spcs_nm} on {price_date} → {price} {unit}")

        cursor.execute("SELECT name FROM RecipeIngredientMaster")
        ingredient_names = [r[0] for r in cursor.fetchall()]

conn.close()
