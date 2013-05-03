#!/bin/bash

source $(dirname $0)/util.sh

REFPKG=$1
INPUT_SEQS=$2
DEDUP_SEQS=$3
DEDUP_INFO=$4
ALIGNED_SEQS=$5
SPLIT_MAP=$6

deduplicate_sequences.py --split-map ${SPLIT_MAP} --deduplicated-sequences-file ${DEDUP_INFO} ${INPUT_SEQS} ${DEDUP_SEQS}
refpkg_align.py align --output-format fasta ${REFPKG} ${DEDUP_SEQS} ${ALIGNED_SEQS}
