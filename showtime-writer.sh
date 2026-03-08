#!/bin/bash

OUTFILE="/home/sigmoid/showtime.log"

echo "[showtime] Writing time every minute to: $OUTFILE"

while true
do
    date >> "$OUTFILE"
    sleep 60
done

