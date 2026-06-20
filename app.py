from fastapi import FastAPI, UploadFile, File
import google.generativeai as genai
from PIL import Image
import os

app = FastAPI()

genai.configure(
    api_key=os.getenv("GEMINI_API_KEY")
)

model = genai.GenerativeModel("gemini-2.5-flash")


@app.post("/describe")
async def describe_image(file: UploadFile = File(...)):
    image = Image.open(file.file)

    response = model.generate_content([
        "Describe this image for a blind person.",
        image
    ])

    return {
        "description": response.text
    }


@app.get("/")
def root():
    return {
        "message": "ADHI Vision API is running successfully 🚀"
    }


# ADD THIS
@app.get("/check")
def check():
    return {
        "key_exists": os.getenv("GEMINI_API_KEY") is not None
    }