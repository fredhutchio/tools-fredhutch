#!/bin/bash

source $(dirname $0)/util.sh
source $1

PLACED_SEQS=$(extify jplace ${PLACED_SEQS})
NBC_SEQS=$(extify fasta ${NBC_SEQS})

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
    -c ${REFPKG} \
    -j ${GALAXY_SLOTS:-4} \
    --pp \
    --sqlite ${CLASS_DB} \
    --classifier hybrid2 \
    --nbc-sequences ${NBC_SEQS} \
    ${PLACED_SEQS}

multiclass_concat.py --dedup-info ${DEDUP_INFO} ${CLASS_DB}
