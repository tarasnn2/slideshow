#!/bin/bash

TMPDIR=/tmp

while getopts p:t: flag; do
  case "${flag}" in
  p) prefix=${OPTARG} ;;
  t) timeShow=${OPTARG} ;;
  esac
done

basePath=$(dirname -- "$0")

if test -f ${basePath}/${prefix}.barrier; then
  exho "${prefix} barrier exist, exit"
  exit 0
fi

FILE="${basePath}/${prefix}_image.lst"
COUNTER_FILE="${basePath}/${prefix}_counter.lst"
COUNTER=$(cat $COUNTER_FILE)
countString=$(wc -l $FILE)
countArr=(${countString// / })
COUNT=${countArr[0]}

if (($COUNTER >= $COUNT)); then
  echo "reset counter"
  COUNTER=0
fi

LAST_LINE=$(expr $COUNT - $COUNTER)

while read -r line; do
  COUNTER=$(expr $COUNTER + 1)
  echo $COUNTER >${basePath}/${prefix}_counter.lst
  echo $line >${basePath}/${prefix}_current.lst

  rm -rdf "${TMPDIR}${line}"
  mkdir -p "${TMPDIR}${line}"
  while read -r file; do
    fileArr=(${file//// })
    convert -pointsize 200 -fill black -draw "text 10,250 \"${fileArr[3]} ${fileArr[4]}\"" -channel RGBA -fill darkred -stroke magenta "$file" "$TMPDIR$file"
  done < <(find "${line}" -type f)
  #`imv-x11 -r -f -t$timeShow -x -s full "${TMPDIR}${line}"`
  $(DISPLAY=:1 imv-x11 -r -f -t$timeShow -x -s full "${TMPDIR}${line}")
  rm -rdf "${TMPDIR}${line}"
done < <(tail -n $LAST_LINE $FILE)
