FROM python:2.7-slim

RUN mkdir /app
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

LABEL version="2.0"

VOLUME ["/app/public"]

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT instruction allows the execution of a script after the docker container starts
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD flask run --host=0.0.0.0 --port=5000
