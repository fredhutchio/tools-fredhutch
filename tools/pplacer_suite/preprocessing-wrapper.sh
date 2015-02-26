#!/bin/bash

source $1

deduplicate_sequences.py \
    --split-map ${SPLIT_MAP} \
    --deduplicated-sequences-file ${DEDUP_INFO} \
    ${INPUT_SEQS} \
    ${DEDUP_SEQS}

# adapted from yapp/bin/refpkg_align
ref_sto=$(taxit rp ${REFPKG} aln_sto)
profile=$(taxit rp ${REFPKG} profile)

sto=$(mktemp -u).sto

cmalign --cpu ${GALAXY_SLOTS:-4} -o "$sto" --sfile "${ALIGNED_SCORES}" --noprob --dnaout "$profile" "${DEDUP_SEQS}" | grep -E '^#'

esl-alimerge --dna --outformat afa "$ref_sto" "$sto" | \
    seqmagick convert --output-format fasta --dash-gap - "${ALIGNED_SEQS}"
