#!/bin/bash

source $(dirname $0)/util.sh
source $1

deduplicate_sequences.py \
    --split-map ${SPLIT_MAP} \
    --deduplicated-sequences-file ${DEDUP_INFO} \
    ${INPUT_SEQS} \
    ${DEDUP_SEQS}

refpkg_align.py align \
    --use-mpi --mpi-arguments "-n 24" \
    --output-format fasta \
    ${REFPKG} \
    ${DEDUP_SEQS} \
    ${ALIGNED_SEQS}
