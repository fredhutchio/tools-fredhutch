#!/bin/bash

source $(dirname $0)/util.sh
source $1

classif_table.py \
    --specimen-map ${SPLIT_MAP} \
    --metadata-map ${LABEL_MAP} \
    --rank ${WANT_RANK} \
    --tallies-wide ${TALLIES_WIDE} \
    --by-specimen ${BY_SPECIMEN} \
    ${CLASS_DB} \
    ${BY_TAXON}
