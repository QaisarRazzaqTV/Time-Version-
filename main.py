from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Time Vision AI Server")


class ChatRequest(BaseModel):
    message: str


@app.get("/")
def home():
    return {
        "status": "online",
        "message": "Time Vision AI Server is running"
    }


@app.post("/chat")
def chat(request: ChatRequest):
    return {
        "reply": f"You said: {request.message}"
    }
