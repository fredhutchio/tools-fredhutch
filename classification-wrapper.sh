#!/bin/bash

source $(dirname $0)/util.sh
source $1

classif_rect.py \
    --want-rank ${WANT_RANK} \
    --specimen-map ${SPLIT_MAP} \
    ${CLASS_DB} \
    ${BY_TAXON} \
    ${BY_SPECIMEN} \
    groupBySpecimen.csv

csvjoin -c "specimen" ${LABEL_MAP} groupBySpecimen.csv | \
    csvcut -C 3 > ${GROUP_BY_SPECIMEN}
