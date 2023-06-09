#!/bin/bash

if [ $# -eq 0 ]; then

  echo "Usage: $0 <url_file>"

  exit 1

fi

url_file="$1"

if [ ! -f "$url_file" ]; then

  echo "File not found: $url_file"

  exit 1

fi

output_file="output.txt"

urls=($(cat "$url_file"))

for url in "${urls[@]}"; do

  echo "Checking HTTP version for $url"

  response_headers=$(curl -sIL "$url" | tac)

  http_version=$(echo "$response_headers" | awk '/^HTTP/ {print $1; exit}')

  if [[ -n "$http_version" ]]; then

    echo "HTTP version: $http_version"

  else

    echo "Unable to determine HTTP version"

  fi

  echo

  echo "Url - $url" >> "$output_file"

  echo "Http version - $http_version" >> "$output_file"

  echo >> "$output_file"

  echo

done | tee >(awk '{print "Url - ("$0")"}; getline; {print "Http version - ("$0">

echo "Output saved to $output_file"
