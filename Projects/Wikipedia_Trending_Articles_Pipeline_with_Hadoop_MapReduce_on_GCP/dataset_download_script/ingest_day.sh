#!/bin/bash
DAY=$1
Y=${DAY:0:4}; M=${DAY:5:2}; D=${DAY:8:2}
hadoop fs -mkdir -p /user/mayank0953/wiki/raw/dt=$DAY
for H in $(seq -w 0 23); do
  F="pageviews-${Y}${M}${D}-${H}0000.gz"
  echo "$(date +%T) Fetching $F"
  curl -sfL --retry 3 "https://dumps.wikimedia.org/other/pageviews/${Y}/${Y}-${M}/${F}" \
    | hadoop fs -D dfs.replication=1 -put -f - /user/mayank0953/wiki/raw/dt=$DAY/$F
  sleep 2
done