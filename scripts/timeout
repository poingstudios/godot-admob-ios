#!/bin/bash
(
    sleep 5

    kill -s SIGTERM $$ && kill -0 $$ || exit 0
    sleep 1
    kill -s SIGKILL $$
) 2> /dev/null &

exec "$@"