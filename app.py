from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import google.generativeai as genai
from PIL import Image
import os
import json
import tempfile

app = FastAPI(title="ADHI API")

# --- CORS ---------------------------------------------------------------
# Your Flutter web build (Vercel) and your FastAPI backend (Render) live on
# different origins, so the browser blocks fetch calls unless the API sends
# CORS headers back. allow_origins=["*"] gets you unblocked for the demo;
# before final submission, swap "*" for your actual Vercel URL.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

JSON_CONFIG = {"response_mime_type": "application/json"}

vision_model = genai.GenerativeModel("gemini-2.5-flash", generation_config=JSON_CONFIG)
audio_model = genai.GenerativeModel("gemini-2.5-flash", generation_config=JSON_CONFIG)


def _safe_json(text: str, fallback: dict) -> dict:
    """Gemini is asked to return pure JSON, but models occasionally wrap it
    in markdown fences or add stray text. Try a few fallbacks before giving
    up so the API never 500s on a parsing hiccup."""
    try:
        return json.loads(text)
    except Exception:
        cleaned = text.strip().strip("`")
        if cleaned.lower().startswith("json"):
            cleaned = cleaned[4:]
        try:
            return json.loads(cleaned)
        except Exception:
            return fallback


@app.get("/")
async def root():
    return {"status": "ADHI API is running"}


@app.post("/describe")
async def describe_image(file: UploadFile = File(...)):
    """Vision Assistant. Returns a scene description plus structured
    object/hazard/text fields so the Flutter UI can populate the
    'Environmental Context' and 'Alerts & Feedback' panels."""
    try:
        image = Image.open(file.file)

        prompt = (
            "You are an accessibility assistant describing a scene for a blind "
            "or low-vision user. Analyze the image and respond ONLY with valid "
            "JSON, no markdown, no commentary, in exactly this schema:\n"
            "{\n"
            '  "description": "one clear, spoken-style description of the scene",\n'
            '  "objects": ["notable objects or people in the scene"],\n'
            '  "hazards": ["tripping hazards, obstacles, or safety risks - empty list if none"],\n'
            '  "text_detected": "any readable text or signage in the image, or null"\n'
            "}"
        )

        response = vision_model.generate_content([prompt, image])

        data = _safe_json(
            response.text,
            {"description": response.text, "objects": [], "hazards": [], "text_detected": None},
        )

        return {
            "description": data.get("description", ""),
            "objects": data.get("objects") or [],
            "hazards": data.get("hazards") or [],
            "text_detected": data.get("text_detected"),
        }

    except Exception as e:
        return {"error": str(e)}


@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):
    """Hearing Assistant. Accepts a WAV clip recorded in the Flutter app,
    returns a transcript plus an environmental sound classification so the
    UI can drive the 'Instant Urgent Sound Alerts' panel."""
    tmp_path = None
    try:
        audio_bytes = await file.read()

        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
            tmp.write(audio_bytes)
            tmp_path = tmp.name

        uploaded = genai.upload_file(path=tmp_path, mime_type="audio/wav")

        prompt = (
            "You are an accessibility assistant for a deaf or hard-of-hearing "
            "user. Listen to this short audio clip and respond ONLY with valid "
            "JSON, no markdown, no commentary, in exactly this schema:\n"
            "{\n"
            '  "transcript": "spoken words transcribed exactly, empty string if none",\n'
            '  "sound_event": "one of: speech, siren, smoke_alarm, knocking, shouting, doorbell, none",\n'
            '  "urgent": true or false (true only for siren, smoke_alarm, or shouting)\n'
            "}"
        )

        response = audio_model.generate_content([prompt, uploaded])

        data = _safe_json(
            response.text,
            {"transcript": "", "sound_event": "none", "urgent": False},
        )

        return {
            "transcript": data.get("transcript", ""),
            "sound_event": data.get("sound_event", "none"),
            "urgent": bool(data.get("urgent", False)),
        }

    except Exception as e:
        return {"error": str(e)}
    finally:
        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)