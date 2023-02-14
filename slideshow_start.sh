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

if ((COUNTER >= COUNT)); then
  echo "reset counter"
  COUNTER=0
fi

LAST_LINE=$(expr $COUNT - $COUNTER)

while read -r line; do
  COUNTER=$(expr $COUNTER + 1)
  echo "$COUNTER" >"${basePath}/${prefix}_counter.lst"
  echo "$line" >"${basePath}/${prefix}_current.lst"

  rm -rdf "${TMPDIR}${line}"
  mkdir -p "${TMPDIR}${line}"
  while read -r file; do
    IFS='/' read -r -a fileArr <<<"$file"
    convert "$file" -size 1300x150! -background none caption:"${fileArr[3]} ${fileArr[4]}" -geometry +10+10 -composite "$TMPDIR$file"
  done < <(find "${line}" -type f -name "*.jpg" -o -iname "*.JPG")
  $(DISPLAY=:1 imv-x11 -r -f -t$timeShow -x -s full "${TMPDIR}${line}")
  #$(imv-x11 -r -f -t$timeShow -x -s full "${TMPDIR}${line}")
  rm -rdf "${TMPDIR}${line}"
done < <(tail -n "${LAST_LINE}" "${FILE}")
