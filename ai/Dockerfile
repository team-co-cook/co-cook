FROM python:3.8.10

RUN mkdir /ai
RUN ls
COPY ./ /ai
WORKDIR /ai
RUN ls
RUN apt-get update
RUN apt-get install -y ffmpeg
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

