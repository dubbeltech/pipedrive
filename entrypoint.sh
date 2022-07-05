#!/bin/sh



flask crontab add

python project/app.py

exec "$@"
