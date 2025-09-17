#!/bin/bash

BLUE="\e[32m"
ORANGE="\e[33m"
GREEN="\e[38;2;0;255;0m"
YELLOW="\e[38;2;255;255;0m"
RED="\e[38;2;255;0;0m"
LIGHTBLUE="\e[38;2;173;216;230m"
NC="\e[0m" # Reset

THRESHOLD=10  # ms threshold
INTERVAL=5     # default
TARGET=""
HISTORY_LINES=100  # set this to the number of lines of history to show from the logs

# Parse options
while getopts "i:t:" opt; do
    case $opt in
        i)
            INTERVAL=$OPTARG
            ;;
        t)
            THRESHOLD=$OPTARG
            ;;
        *)
            echo "Usage: $0 [-i interval] [-t threshold] target"
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))
TARGET="$1"

# find the log file (or it will be created)
LOGTARGET=$(echo "$TARGET" | sed 's/[^a-zA-Z0-9]/_/g')
LOGFILE="${LOGTARGET}.log"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 [-i interval] [-t threshold] target"
    exit 1
fi

# show prior history
if [[ -f "$LOGFILE" ]]; then
    tail -n "$HISTORY_LINES" "$LOGFILE"
    echo
fi

# print timestamp
LAST_HOUR=$(date "+%Y-%m-%d %I%p")
START_TS=$(date "+%Y-%m-%d %I:%M%p")
echo -e "${LIGHTBLUE}$START_TS: target=$TARGET, threshold=${THRESHOLD}ms, interval=${INTERVAL}s${NC}"
printf "\n" >> "$LOGFILE"
echo "$START_TS: target=$TARGET, threshold=${THRESHOLD}ms, interval=${INTERVAL}s" >> "$LOGFILE"

while true; do
    HOUR=$(date "+%Y-%m-%d %I%p")
    if [[ "$HOUR" != "$LAST_HOUR" ]]; then
        echo
        echo -e "${LIGHTBLUE}$HOUR:"
        printf "\n" >> "$LOGFILE"
        echo "$HOUR:" >> "$LOGFILE"
        LAST_HOUR="$HOUR"
    fi
    PING_OUTPUT=$(ping -c 1 -W 2 "$TARGET" 2>/dev/null)
    if echo "$PING_OUTPUT" | grep -q "time="; then
        TIME_MS=$(echo "$PING_OUTPUT" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}' | awk -F. '{print $1}')
        if (( TIME_MS > THRESHOLD )); then
            printf "${ORANGE}:${NC}"
            echo -n ":" >> "$LOGFILE"
        else
            printf "${BLUE}.${NC}"
            echo -n "." >> "$LOGFILE"
        fi
    else
        printf "${RED}x${NC}"
        echo -n "x" >> "$LOGFILE"
    fi
    sleep $INTERVAL
done
