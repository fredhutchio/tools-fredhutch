#!/bin/bash

source $(dirname $0)/util.sh
source $1

classif_table.py \
    --specimen-map ${SPLIT_MAP} \
    --rank ${WANT_RANK} \
    --tallies-wide ${BY_SPECIMEN} \
    --by-specimen groupBySpecimen.csv \
    ${CLASS_DB} \
    ${BY_TAXON}

csvjoin -c "specimen" ${LABEL_MAP} groupBySpecimen.csv | \
    csvcut -C 3 > ${GROUP_BY_SPECIMEN}
