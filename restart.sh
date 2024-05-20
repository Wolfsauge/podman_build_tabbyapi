#!/usr/bin/env bash

set -uxo pipefail

LOG=/app/tabbyAPI.log
PID="$(pidof python3)"

if [ ! -z "$PID" ]
then
  kill $PID
  tail --pid=$PID -f /dev/null
fi

(
  cd /app
  python3 main.py >> $LOG 2>&1
) &

set +x
sleep 1 && tail -n 24 $LOG && \
  echo && echo Check $LOG for more log files..

