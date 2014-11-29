#!/usr/bin/env bash

set -e

cd "$(dirname "$BASH_SOURCE")"

tsync="../bin/tsync"

if [ ! -d fixtures ]; then
  
  echo "Creating fixtures..."

  mkdir fixtures

  for i in {1..1000}; do
    < /dev/urandom\
      | LC_CTYPE=C tr -dc 'a-z0-9'\
      | fold -w 16\
      | head -n 1\
    > fixtures/${i}.txt
  done
fi

time $tsync -c 9999 'fixtures/**/*.txt' 'sed s/a/b/' 'tr [:lower:] [:upper:]' build
