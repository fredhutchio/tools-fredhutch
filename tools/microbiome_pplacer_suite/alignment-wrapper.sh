#!/bin/bash

source $1

# adapted from yapp/bin/refpkg_align
ref_sto=$(taxit rp ${REFPKG} aln_sto)
profile=$(taxit rp ${REFPKG} profile)

sto=$(mktemp -u).sto

cmalign --cpu ${GALAXY_SLOTS:-4} -o "$sto" --sfile "${ALIGNED_SCORES}" --noprob --dnaout "$profile" "${INPUT_SEQS}" | grep -E '^#'

esl-alimerge --dna --outformat afa "$ref_sto" "$sto" | \
    seqmagick convert --output-format fasta --dash-gap - "${ALIGNED_SEQS}"
