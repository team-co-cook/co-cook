FROM python:3.8.10

COPY ./ /ai
WORKDIR /ai

RUN pip install -r requirements.txt

EXPOSE 3000

CMD ["gunicorn" -"k" "uvicorn.workers.UvicornWorker" "--access-logfile" "./gunicorn-access.log" "main:app" "--bind" "127.0.0.1:8000" "--workers" "2" "--daemon"]