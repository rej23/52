FROM python:3.9-slim

WORKDIR /myweb

COPY . /myweb

RUN pip install -r requirements.txt

EXPOSE 80

CMD ["python", "web.py"]