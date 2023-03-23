#!/bin/bash

TMPDIR=/tmp/special/slideshow

while getopts p:t: flag; do
  case "${flag}" in
  p) prefix=${OPTARG} ;;
  t) timeShow=${OPTARG} ;;
  esac
done

basePath=$(dirname -- "$0")

if test -f "${basePath}/${prefix}.barrier"; then
  exho "${prefix} barrier exist, exit"
  exit 0
fi

FILES="${basePath}/${prefix}_image.lst"
COUNTER_FILE="${basePath}/${prefix}_counter.lst"
COUNTER=$(cat "$COUNTER_FILE")
countString=$(wc -l "$FILES")
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
  fileArr=()
  while read -r file; do
    IFS='/' read -r -a fileArr <<<"$file"
    if [ ${#fileArr[@]} -eq 0 ]; then
      echo "Empty array"
    else
      convert "$file" -size 2000x300! -background none caption:"${fileArr[5]} ${fileArr[6]}" -geometry +10+10 -composite "$TMPDIR$file"
    fi
  done < <(find "${line}" -maxdepth 1 -type f -name "*.jpg" -o -iname "*.JPG")
  if [ ${#fileArr[@]} -eq 0 ]; then
    echo "Empty array"
  else
    $(DISPLAY=:1 imv-x11 -r -f -t$timeShow -x -s full "${TMPDIR}${line}")
    #$(imv-x11 -r -f -t$timeShow -x -s full "${TMPDIR}${line}")
  fi
  rm -rdf "${TMPDIR}${line}"
done < <(tail -n "${LAST_LINE}" "${FILES}")
