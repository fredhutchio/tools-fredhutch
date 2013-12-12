#!/bin/bash

source $(dirname $0)/util.sh
source $1

PLACED_SEQS=$(extify jplace ${PLACED_SEQS})
FILTERED_SEQS=$(extify fasta ${FILTERED_SEQS})

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
    --nbc-sequences ${FILTERED_SEQS} \
    --no-pre-mask \
    ${REDUPED_SEQS}

multiclass_concat.py ${CLASS_DB}
