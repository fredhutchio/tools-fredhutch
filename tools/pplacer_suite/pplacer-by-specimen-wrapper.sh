#!/bin/bash

source $(dirname $0)/util.sh
source $1

PPLACER_DEFAULT_ARGS="-j ${GALAXY_SLOTS:-4} -p --inform-prior --prior-lower 0.01 --map-identity"

SPECIMENS=$(cut -d, -f2 ${SPLIT_MAP} | sort -u)
for SPECIMEN in ${SPECIMENS}; do
    grep -w "${SPECIMEN}" ${SPLIT_MAP} > specimen-map.csv
    cut -d, -f1 specimen-map.csv > specimen-reads.txt
    seqmagick convert --include-from-file specimen-reads.txt --input-format fasta ${INPUT_SEQS} specimen-seqs.fasta

    deduplicate_sequences.py \
        --split-map specimen-map.csv \
        --deduplicated-sequences-file dedup_info.${SPECIMEN}.csv \
        specimen-seqs.fasta \
        specimen-dedup.fasta

    refpkg_align.py align \
        --use-mpi --mpi-arguments "-n ${GALAXY_SLOTS:-4}" \
        --output-format fasta \
        --stdout specimen-scores.txt \
        ${REFPKG} \
        specimen-dedup.fasta \
        specimen-aligned.fasta

    pplacer \
        ${PPLACER_DEFAULT_ARGS} \
        -c ${REFPKG} \
        -o placed.${SPECIMEN}.jplace \
        specimen-aligned.fasta
done

cat dedup_info.*.csv > ${DEDUP_INFO}
guppy mft -o ${PLACED_SEQS} placed.*.jplace
