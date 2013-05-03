#!/bin/bash

source $(dirname $0)/util.sh

# inputs

RAW_SEQS=$1
INPUT_QUAL=$2
BARCODES=$3
PRIMER=$4
REVERSE_COMPLEMENT=$5 # <- TRUE/FALSE
PLATE_JSON=$6

# outputs

FILTERED_SEQS=$7 # <- .fasta
FILTER_REPORT=$8 # <- .txt
FILTER_DETAILS=$9 # <- .csv.bz2; these are used in the sequencing quality report
SPLIT_MAP=${10} # <- .csv
SEQ_QUAL_REPORT=${11} # <- txt?

# http://qiime.org/scripts/split_libraries.html

seqmagick quality-filter \
    --input-qual $(extify qual ${INPUT_QUAL}) \
    --barcode-file $(extify csv ${BARCODES}) \
    --primer "${PRIMER}" \
    --report-out ${FILTER_REPORT} \
    --details-out ${FILTER_DETAILS} \
    --map-out ${SPLIT_MAP} \
    --barcode-header \
    --min-length 350 \
    --min-mean-quality 35 \
    --quality-window 30 \
    --quality-window-prop 0.9 \
    --quality-window-mean-qual 15 \
    $(extify fasta ${RAW_SEQS}) \
    $(extify fasta ${FILTERED_SEQS})

if [[ ${REVERSE_COMPLEMENT} == "TRUE" ]]; then
    seqmagick mogrify \
        --reverse-complement \
        $(extify fasta ${FILTERED_SEQS})
fi

# TODO: separate tool for concatenating seq data (and reverse complementing them?)
#cat [12]*Reads.fasta | seqmagick convert --input-format fasta - combined.fasta --reverse-complement
#cat [12]*.map.csv > combined.map.csv

sequencing_quality_report.py ${PLATE_JSON} -t "Quality report" -o ${SEQ_QUAL_REPORT}
