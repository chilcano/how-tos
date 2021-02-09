#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --url*|-u*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no `=`
      URL="${1#*=}"
      ;;
    --file*|-f*)
      if [[ "$1" != *=* ]]; then shift; fi
      FILE="${1#*=}"
      ;;
    --help|-h)
      printf "Meaningful help message" # Flag argument
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument\n"
      exit 1
      ;;
  esac
  shift
done 

echo "FILE = $FILE"
echo "URL = $URL"
echo "HELP = $HELP"
echo "------------"
