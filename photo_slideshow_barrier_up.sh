#!/bin/bash

basePath=$(dirname -- "$0")

nohup "$basePath/slideshow_barrier_up.sh" -p photo >/dev/null 2>&1 &
