FROM python:3.8
MAINTAINER Seetha Ram "ceetharamm@gmail.com"
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
