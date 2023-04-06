from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import shutil
from pathlib import Path
from pydub import AudioSegment
import datetime
import speech_recognition as sr
import logging
import voice_method as vm
import image_method as im
import requests

logging.basicConfig(filename='app.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s: %(message)s')

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/upload")
async def upload_audio1(audio: UploadFile = File(...)):
    # 저장할 디렉토리 지정
    today = datetime.date.today()
    formatted_date = today.strftime('%m%d%Y')
    time = datetime.datetime.now()
    formatted_date_time = time.strftime('%Y%m%d%H%M')
    save_path = Path("uploaded_files/"+ formatted_date)
    save_path.mkdir(exist_ok=True)

    # mp3 파일을 저장할 경로 지정
    audio_path = save_path / (formatted_date_time+'_'+audio.filename.split(".")[0] + ".wav")

    # 파일 저장
    with audio_path.open("wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    # 오디오 처리
    audio_data = AudioSegment.from_file(audio_path, format="m4a")
    audio_data.export(audio_path, format="wav")
    
    result = recognize_speech(str(audio_path))
    if result != '다음' and result != '다시' and result != '이전' and result != '타이머':
        return {"message": "명령어가 아닙니다", "status": 204, "result" : result}
    return {"message": "성공", "status": 200, "result" : result}

@app.post("/upload/dj")
async def upload_audio2(audio: UploadFile = File(...)):
    # 저장할 디렉토리 지정
    today = datetime.date.today()
    formatted_date = today.strftime('%m%d%Y')
    time = datetime.datetime.now()
    formatted_date_time = time.strftime('%Y%m%d%H%M')
    save_path = Path("uploaded_files_dj/"+ formatted_date)
    save_path.mkdir(exist_ok=True)
    
    # 오디오 파일을 저장할 경로 지정
    audio_path = save_path / (formatted_date_time+'_'+ audio.filename)
    # 파일 저장
    with audio_path.open("wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    # 오디오 처리
    audio_data = AudioSegment.from_file(audio_path, format="m4a")
    audio_data.export(audio_path, format="wav")
    # 저장한 파일에서 라벨 추론
    label = vm.result(audio_path)
    result = ""
    if label == "before":
        result = "이전"
    elif label == "next":
        result = "다음"
    elif label == "replay":
        result = "다시"
    elif label == "timer":
        result = "타이머"

    return {"message": "조회 성공", "status": 200, "result": result}


@app.post("/upload/ingredient")
async def upload_audio3(audio: UploadFile = File(...)):
    # 저장할 디렉토리 지정
    today = datetime.date.today()
    formatted_date = today.strftime('%m%d%Y')
    time = datetime.datetime.now()
    formatted_date_time = time.strftime('%Y%m%d%H%M')

    save_path = Path("uploaded_files/"+ formatted_date)
    save_path.mkdir(exist_ok=True)

    # mp3 파일을 저장할 경로 지정
    audio_path = save_path / (formatted_date_time+'_'+audio.filename.split(".")[0] + ".wav")

    # 파일 저장
    with audio_path.open("wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    # 파일 확장자 사용하여 오디오 형식 지정
    file_extension = audio.filename.split(".")[-1]
    
    # 오디오 처리
    audio_data = AudioSegment.from_file(audio_path, format="m4a")
    audio_data.export(audio_path, format="wav")
    
    result = recognize_speech(str(audio_path))
    if result == "음성 인식을 할 수 없습니다.":
        return {"message" : result, 'status' : 400, 'data' : None}

    response = requests.get('http://j8b302.p.ssafy.io:8080/api/v1/search/ingredient/'+ result)
    data = response.json()
    isIn = data['status']

    if isIn == 200:
        return {'message' : result+'은(는) 있는 재료입니다.', 'status' : 200, 'data' : result}

    else :
        return {'message' : result+'은(는) 없는 재료입니다.', 'status' : 204, 'data' : result}

def recognize_speech(file_path):
    recognizer = sr.Recognizer()
    with sr.AudioFile(file_path) as source:
        audio = recognizer.record(source)
    try:
        text = recognizer.recognize_google(audio, language="ko-KR")
    except sr.UnknownValueError:
        text = "음성 인식을 할 수 없습니다."
    return text

@app.post("/upload/img")
async def upload_img(image: UploadFile = File(...)):
    today = datetime.date.today()
    formatted_date = today.strftime('%m%d%Y')
    time = datetime.datetime.now()
    formatted_date_time = time.strftime('%Y%m%d%H%M')
    save_path = Path("uploaded_files_hs/"+ formatted_date)
    save_path.mkdir(exist_ok=True)

    # image 파일을 저장할 경로 지정
    image_path = save_path / (formatted_date_time+'_'+ image.filename)
    # 파일 저장
    with image_path.open("wb") as buffer:
        shutil.copyfileobj(image.file, buffer)
        result = await im.find_image(image.file)
    
    return result

