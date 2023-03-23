from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import shutil
from pathlib import Path
from pydub import AudioSegment

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

@app.post("/upload/")
async def upload_audio(audio: UploadFile = File(...)):
    # 저장할 디렉토리 지정
    save_path = Path("uploaded_files")
    save_path.mkdir(exist_ok=True)

    # mp3 파일을 저장할 경로 지정
    audio_path = save_path / audio.filename

    # 파일 저장
    with audio_path.open("wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    # # 파일 확장자 사용하여 오디오 형식 지정
    # file_extension = audio.filename.split(".")[-1]
    
    # # 오디오 처리
    # audio_data = AudioSegment.from_file(audio_path, format=file_extension)

    return {"filename": audio.filename, "path": str(audio_path)}
