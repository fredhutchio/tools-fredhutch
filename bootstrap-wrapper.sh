#!/bin/bash

source $(dirname $0)/util.sh
source $1

python $(dirname $0)/bootstrap.py \
    --plate ${PLATE_ID} \
    --zone ${ZONE_ID} \
    --barcodes ${BARCODES} \
    --labels ${LABELS} \
    --metadata ${METADATA} \
    - < ${SAMPLE_INFO}
