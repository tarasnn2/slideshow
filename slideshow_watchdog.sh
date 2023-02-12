#!/bin/bash

while getopts p:t: flag
do
    case "${flag}" in
	p) prefix=${OPTARG};;
	t) timeShow=${OPTARG};;
    esac
done

basePath=$(dirname -- "$0";)

slider_pid=`pgrep slideshow_start`

if [ ! -z "$slider_pid" ]
then
    echo "slider alredy running, exit"
    exit 0
fi

nohup $basePath/slideshow_start.sh -p $prefix -t $timeShow >/dev/null 2>&1 &
