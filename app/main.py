from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class TextPayload(BaseModel):
    text: str

@app.post("/analyze")
async def analyze(payload: TextPayload):
    text = payload.text
    word_count = len(text.split())
    char_count = len(text)
    return {
        "original_text": text,
        "word_count": word_count,
        "character_count": char_count
    }