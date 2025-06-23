#!/bin/sh

: "${MYSQL_HOST:=db}"
: "${MYSQL_PORT:=3306}"

echo "▶ Waiting for MySQL at $MYSQL_HOST:$MYSQL_PORT ..."
while ! nc -z $MYSQL_HOST $MYSQL_PORT; do
  sleep 1
done

echo "✔ MySQL is up — starting FastAPI"
exec uvicorn app:app --host 0.0.0.0 --port 8000
