#!/bin/bash

source $(dirname $0)/util.sh
source $1

csvjoin -c "specimen" ${GROUP_BY_SPECIMEN} ${METADATA} | \
    csvcut -c "specimen,${COLUMNS}" > ${DECORATED_GROUP_BY_SPECIMEN}

# drop duplicate columns (thanks, Erick!)
#csvcut -c $(head -n 1 addresses.csv | sed "s/,/\n/g" | sort |uniq | paste -s -d",")
