#!/bin/bash

source $(dirname $0)/util.sh
source $1

INPUT_QUAL=$(extify qual ${INPUT_QUAL})
BARCODES=$(extify csv ${BARCODES})
RAW_SEQS=$(extify fasta ${RAW_SEQS})

seqmagick quality-filter \
    --input-qual ${INPUT_QUAL} \
    --barcode-file ${BARCODES} \
    --primer "${PRIMER}" \
    --report-out ${FILTER_REPORT} \
    --details-out ${FILTER_DETAILS} \
    --map-out ${SPLIT_MAP} \
    --barcode-header \
    --min-length ${MIN_LENGTH} \
    --min-mean-quality ${MIN_QUALITY} \
    --quality-window 30 \
    --quality-window-prop 0.9 \
    --quality-window-mean-qual 15 \
    ${RAW_SEQS} \
    filtered.fasta

if [[ ${REVERSE_COMPLEMENT} == "TRUE" ]]; then
    seqmagick mogrify \
        --reverse-complement \
        filtered.fasta
fi

mv filtered.fasta ${FILTERED_SEQS}

sequencing_quality_report.py ${PLATE_JSON} -t "Sequencing quality report" -o ${SQR_DIR}

cat <<EOF > ${SQR}
<!DOCTYPE HTML>
<html lang="en-US">
  <head/>
  <body>
    <a href="index.html">Sequencing quality report</a>
  </body>
</html>
EOF
