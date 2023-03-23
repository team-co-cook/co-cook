from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import shutil
from pathlib import Path
from pydub import AudioSegment
import datetime
import speech_recognition as sr

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/hello")
async def hello():
    return{"message" : "hello"}

@app.post("/upload")
async def upload_audio(audio: UploadFile = File(...)):
    # 저장할 디렉토리 지정
    today = datetime.date.today()
    formatted_date = today.strftime('%m%d%Y')
    save_path = Path("uploaded_files/"+ formatted_date)
    save_path.mkdir(exist_ok=True)

    # mp3 파일을 저장할 경로 지정
    audio_path = save_path / (audio.filename.split(".")[0] + ".wav")

    # 파일 저장
    with audio_path.open("wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    # 파일 확장자 사용하여 오디오 형식 지정
    file_extension = audio.filename.split(".")[-1]
    
    # 오디오 처리
    audio_data = AudioSegment.from_file(audio_path, format="m4a")
    audio_data.export(audio_path, format="wav")
    
    result = recognize_speech(str(audio_path))
    return {"filename": audio.filename, "path": str(audio_path), "result" : result}

def recognize_speech(file_path):
    recognizer = sr.Recognizer()
    with sr.AudioFile(file_path) as source:
        audio = recognizer.record(source)
    try:
        text = recognizer.recognize_google(audio, language="ko-KR")
    except sr.UnknownValueError:
        text = "음성 인식을 할 수 없습니다."
    return text