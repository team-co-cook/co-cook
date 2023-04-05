FROM python:3.8.10

RUN mkdir /ai
RUN ls
COPY ./ /ai
WORKDIR /ai
RUN ls
RUN apt-get update
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000

CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "--access-logfile", "./gunicorn-access.log", "main:app", "--bind", "0.0.0.0:8000", "--workers", "2", "--daemon"]
