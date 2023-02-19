#!/bin/bash

usage() {
  cat <<EOF
usage: $0 options

This script check the program in memory and handle slider process depend of result

OPTIONS:
   -p      Name of process
EOF
}

while getopts p: flag; do
  case $flag in
  p)
    process=${OPTARG}
    echo "${process}"
    ;;
  *)
    usage
    exit 1
    ;;
  esac
done

if [ -z "$process" ]; then
  usage
  exit 1
fi

basePath=$(dirname -- "$0")
pid=$(pgrep "${process}")

if [ -n "$pid" ]; then
  echo "${process} is starting! the slider process will stop"
  nohup "$basePath/art_slideshow_barrier_up.sh" >/dev/null 2>&1 &
  nohup "$basePath/photo_slideshow_barrier_up.sh" >/dev/null 2>&1 &
  nohup "$basePath/slideshow_stop.sh" >/dev/null 2>&1 &
else
  echo "${process} isn't starting! the slider process will start"
  nohup "$basePath/art_slideshow_barrier_down.sh" >/dev/null 2>&1 &
  nohup "$basePath/photo_slideshow_barrier_down.sh" >/dev/null 2>&1 &
fi
