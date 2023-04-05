FROM python:3.8.10

RUN mkdir ai
COPY ./ /ai
WORKDIR /ai
RUN apt-get update
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000

CMD ["gunicorn" "-k" "uvicorn.workers.UvicornWorker" "--access-logfile" "./gunicorn-access.log" "main:app" "--bind" "127.0.0.1:8000" "--workers" "2" "--daemon"]

# 베이스 이미지
FROM python:3.8.5

# 작업 폴더 생성
WORKDIR /app

# 의존성 설치
COPY requirements.txt .
RUN apt-get update && apt-get install -y portaudio19-dev
RUN apt-get update && apt-get install -y libsndfile1
RUN pip install --no-cache-dir -r requirements.txt

# 앱 소스 코드 복사
COPY . .

# 컨테이너 실행 시 실행될 명령어
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7777"]