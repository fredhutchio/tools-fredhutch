#!/bin/bash

source $(dirname $0)/util.sh
source $1

SCRIPT_DIR="$(dirname $0)/cbrother_pipeline/code"

FLAGS=""
if [[ ${ALLOW_ANCIENT} == "TRUE" ]]; then
    FLAGS="--allow-ancient"
fi

#ls *.cmd | parallel -j 6 --eta $wd'/code/run_cbrother.py {} {.}.phy cbrother.geno {.}.pp'

python ${SCRIPT_DIR}/setup_cbrother.py ${FLAGS} ${ALIGNMENT} ${GENOTYPE_MAP} cbrother
for CMD in *.cmd; do
    PREFIX="${CMD%.cmd}"
    python ${SCRIPT_DIR}/run_cbrother.py ${CMD} ${PREFIX}.phy cbrother.geno ${PREFIX}.pp
done

pdftk cbrother.*.pdf cat output ${REPORT}
