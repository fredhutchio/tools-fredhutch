#!/bin/bash

set -eux

source $(dirname $0)/util.sh

BIN="/home/matsengrp/local/bin"

# inputs

DEDUP_INFO=$1
REFPKG=$2
ALIGNED_SEQS=$(extify fasta $3)
SPLIT_MAP=$4
PLACED_SEQS=$(extify jplace $5)

# outputs

REDUPED_SEQS=$6
DB=$7
BY_TAXON=$8
BY_SPECIMEN=$9
GROUP_BY_SPECIMEN=${10}

guppy redup -m -d ${DEDUP_INFO} -o ${REDUPED_SEQS} ${PLACED_SEQS}
REDUPED_SEQS=$(extify jplace ${REDUPED_SEQS})

rppr prep_db -c ${REFPKG} --sqlite ${DB}

guppy classify --pp -c ${REFPKG} --sqlite ${DB} --classifier hybrid2 --nbc-sequences ${ALIGNED_SEQS} ${REDUPED_SEQS}

${BIN}/python ${BIN}/multiclass_concat.py ${DB}
${BIN}/python ${BIN}/classif_rect.py --specimen-map ${SPLIT_MAP} ${DB} ${BY_TAXON} ${BY_SPECIMEN} ${GROUP_BY_SPECIMEN}
