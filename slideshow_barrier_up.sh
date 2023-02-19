#!/bin/bash

while getopts p: flag; do
  case "${flag}" in
  p) prefix=${OPTARG} ;;
  esac
done

basePath=$(dirname -- "$0")

touch "${basePath}/${prefix}.barrier"
