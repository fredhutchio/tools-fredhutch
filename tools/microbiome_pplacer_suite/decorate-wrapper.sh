#!/bin/bash

source $(dirname $0)/util.sh
source $1

csvcut -c "specimen,${COLUMNS}" ${METADATA} | \
    csvjoin -c "specimen" ${GROUP_BY_SPECIMEN} - > ${DECORATED_GROUP_BY_SPECIMEN}

# drop duplicate columns (thanks, Erick!)
#csvcut -c $(head -n 1 addresses.csv | sed "s/,/\n/g" | sort |uniq | paste -s -d",")
