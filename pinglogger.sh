#!/bin/bash

GREEN="\e[38;2;0;255;0m"
YELLOW="\e[38;2;255;255;0m"
RED="\e[38;2;255;0;0m"
BLUE="\e[38;2;173;216;230m"
NC="\e[0m" # Reset

THRESHOLD=10  # ms threshold
INTERVAL=5     # default
TARGET=""

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

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 [-i interval] [-t threshold] target"
    exit 1
fi

LAST_HOUR=$(date "+%Y-%m-%d %I%p")
START_TS=$(date "+%Y-%m-%d %I:%M%p")
echo -e "${BLUE}$START_TS:${NC}"

while true; do
    HOUR=$(date "+%Y-%m-%d %I%p")
    if [[ "$HOUR" != "$LAST_HOUR" ]]; then
        echo
        echo "$HOUR:"
        LAST_HOUR="$HOUR"
    fi
    PING_OUTPUT=$(ping -c 1 -W 2 "$TARGET" 2>/dev/null)
    if echo "$PING_OUTPUT" | grep -q "time="; then
        TIME_MS=$(echo "$PING_OUTPUT" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}' | awk -F. '{print $1}')
        if (( TIME_MS > THRESHOLD )); then
            printf "${YELLOW}:${NC}"
        else
            printf "${GREEN}.${NC}"
        fi
    else
        printf "${RED}x${NC}"
    fi
    sleep $INTERVAL
done
