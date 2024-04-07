from typing import Generic, TypeVar
from fastapi import FastAPI
from pydantic import BaseModel
from aimodel import initModel, promptModel
import uvicorn, torch

app = FastAPI()

DataT = TypeVar('DataT')

class CommonResponse(BaseModel, Generic[DataT]):
    status: int
    data: DataT

class UserDialog(BaseModel):
    sentence: str

class answerData(BaseModel):
    result: str # response 결과

class errorData(BaseModel):
    name: str # 에러 메시지 이름
    message: str # 사용자에게 보여줄 에러 메시지



@app.on_event("startup")
async def startup_event():
    await initModel()

@app.get("/")
async def hello():
    return "hello, fastapi!"

@app.post("/chatbot/requests")
async def generateAnswer(request: UserDialog):
    print(request.sentence)
    answer = await promptModel(request.sentence)
    return answerData(result=answer)

if __name__ == "__main__":
    uvicorn.run(app, host="", port=)