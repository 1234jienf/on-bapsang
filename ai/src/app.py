from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from recommend import recommend


app = FastAPI(title="Bapsang AI Recipe Recommendation")

class Req(BaseModel):
    food_name: str = Field(
        ...,
        pattern=r"^[가-힣A-Za-z0-9 ]+$",
        min_length=1,
        max_length=20,
        description="한글·영문·숫자·공백만 허용, 최대 20자"
    )

class Dish(BaseModel):
    recipe_id: str
    name: str
    ingredients: list[str]
    descriptions: str
    review: str
    time: str
    difficulty: str
    portion: str
    method: str
    material_type: str
    image_url: str
    score: float

class Resp(BaseModel):
    food_name: str
    message: str
    recommended_dishes: list[Dish]

@app.post("/recommend", response_model=Resp, status_code=201)
def route_recommend(req: Req):
    try:
        return recommend(req.food_name, top_k=100)
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))