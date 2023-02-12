#!/bin/bash

while getopts p:s: flag
do
    case "${flag}" in
	p) prefix=${OPTARG};;
	s) sourcePath=${OPTARG};;
    esac
done

basePath=$(dirname -- "$0";)

find $sourcePath -type d | grep -vE `cat ${basePath}/${prefix}_exclude.lst` | sort > ${basePath}/${prefix}_image.lst
