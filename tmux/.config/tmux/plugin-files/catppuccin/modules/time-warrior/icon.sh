#!/usr/bin/env sh

TASK="$(timew | sed -n 's/Tracking //p' | tr -d '\n')"
if [ -n "$TASK" ]; then
    printf " "
fi
