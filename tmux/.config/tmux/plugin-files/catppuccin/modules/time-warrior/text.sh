#!/usr/bin/env sh

TASK="$(timew | sed -n 's/Tracking //p' | tr -d '\n')"
TIME="$(timew | sed -n 's/[ ]\+Total[ ]\+//p' | tr -d '\n')"
if [ -n "$TASK" ]; then
    printf " %s %s" "$TASK" "$TIME"
fi
