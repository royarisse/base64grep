#!/bin/bash
# https://serverfault.com/a/876667

word="$1"

if [ -z "$1" ]; then
  echo "Usage: $0 someword"
  exit 1
fi

removePadding() {
  in=$1

  if [ -z "$in" ]; then
    echo "Usage: removePadding Ba5e64E+C0D3D=="
    kill -INT $$
  fi

  # Remove "=" chars first
  in="${in//=/}"

  # Ensure length is multiple of 3 bytes
  remove=$(( ${#in} % 3 ))
  if [ $remove -eq 0 ]; then
    echo ${in}
  else
    echo ${in::-$remove}
  fi
}

# As is, length of 3
normal=$(echo -n "${word}" | base64)
variant1=$(removePadding $normal)

# Prefixed with X, remove first 2 characters (WF)
prefixed=$(echo -n "X${word}" | base64)
removeprefix="${prefixed:2}"
variant2=$(removePadding $removeprefix)

# Prefixed with XX, forced padding, remove first 3 characters (WFh)
doubleprefixed=$(echo -n "XX${word}" | base64)
removeprefix="${doubleprefixed:3}"
variant3=$(removePadding $removeprefix)

echo "Variants: $variant1 $variant2 $variant3"
echo "Regexp:   ($variant1|$variant2|$variant3)"
