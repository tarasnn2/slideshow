#!/bin/bash

basePath=$(dirname -- "$0")

nohup "$basePath/slideshow_barrier_down.sh" -p photo >/dev/null 2>&1 &
