#!/bin/bash
# https://serverfault.com/a/876667

base64unpad() {
  local part="$1"
  local ren remove

  if [ -z "$part" ]; then
    echo "Usage: _base64unpad Ba5e64E+C0D3D=="
    return 1
  fi

  # Remove "=" chars first
  part="${part//=/}"

  # Ensure length is multiple of 3 bytes
  len=${#part}
  remove=$(( ${#part} % 3 ))
  if [ $len -le 3 ] || [ $remove -eq 0 ]; then
    echo "$part"
  else
    echo "$part" | sed -e "s/.\{$remove\}$//"
  fi
}

base64variants() {
  local word="$1"
  local normal variant1 variant2 variant3
  local prefixed removeprefix doubleprefixed

  if [ -z "$word" ]; then
    echo "Usage $0 word"
    return 1
  fi

  # As is, length of 3
  normal=$(echo -n "${word}" | base64)
  variant1=$(base64unpad "$normal")

  # Prefixed with X, remove first 2 characters (WF)
  prefixed=$(echo -n "X${word}" | base64)
  removeprefix="${prefixed:2}"
  variant2=$(base64unpad "$removeprefix")

  # Prefixed with XX, forced padding, remove first 3 characters (WFh)
  doubleprefixed=$(echo -n "XX${word}" | base64)
  removeprefix="${doubleprefixed:3}"
  variant3=$(base64unpad "$removeprefix")

  echo "$variant1 $variant2 $variant3"
}

base64regex() {
  local word="$1"
  local variants

  if [ -z "$word" ]; then
    echo "Usage $0 word"
    return 1
  fi

  variants=$(base64variants "$word")
  echo "(${variants// /|})"
}

base64grep() {
  local word="$1"
  local variants

  if [ -z "$word" ]; then
    echo "Usage $0 word"
    return 1
  fi

  cat | tr -d '\n' | grep -P "$(base64regex $word)" --color
}