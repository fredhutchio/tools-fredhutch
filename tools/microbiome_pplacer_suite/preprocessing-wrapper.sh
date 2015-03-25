#!/bin/bash

source $1

deduplicate_sequences.py \
    --split-map ${SPLIT_MAP} \
    --deduplicated-sequences-file ${DEDUP_INFO} \
    ${INPUT_SEQS} \
    ${DEDUP_SEQS}
