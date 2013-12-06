#!/bin/bash

source $(dirname $0)/util.sh
source $1

PLACED_SEQS=$(extify jplace ${PLACED_SEQS})
ALIGNED_SEQS=$(extify fasta ${ALIGNED_SEQS})

guppy redup \
    -m \
    -d ${DEDUP_INFO} \
    -o ${REDUPED_SEQS} \
    ${PLACED_SEQS}

REDUPED_SEQS=$(extify jplace ${REDUPED_SEQS})

rppr prep_db \
    -c ${REFPKG} \
    --sqlite ${CLASS_DB}

guppy classify \
    --pp \
    -c ${REFPKG} \
    --sqlite ${CLASS_DB} \
    --classifier hybrid2 \
    --nbc-sequences ${ALIGNED_SEQS} \
    ${REDUPED_SEQS}

multiclass_concat.py ${CLASS_DB}

classif_rect.py \
    --want-rank ${WANT_RANK} \
    --specimen-map ${SPLIT_MAP} \
    ${CLASS_DB} \
    ${BY_TAXON} \
    ${BY_SPECIMEN} \
    groupBySpecimen.csv

csvjoin -c "specimen" ${LABEL_MAP} groupBySpecimen.csv | \
    csvcut -C 3 > ${GROUP_BY_SPECIMEN}
