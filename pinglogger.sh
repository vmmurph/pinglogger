#!/bin/bash
TARGET="$1"
INTERVAL=5
LINE=""
LAST_HOUR=""

while true; do
    TIMESTAMP=$(date "+%Y-%m-%d %I%p")
    HOUR=$(date "+%Y-%m-%d %I%p")

    if [[ "$HOUR" != "$LAST_HOUR" && -n "$LINE" ]]; then
        # Print previous hour's line, reset for new hour
        echo "$LAST_HOUR:"
        echo "$LINE"
        LINE=""
    fi

    ping -c 1 -W 2 "$TARGET" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        printf "."; LINE="${LINE}."

    else
        printf "."; LINE="${LINE}x"
    fi

    LAST_HOUR="$HOUR"
    sleep $INTERVAL
done
