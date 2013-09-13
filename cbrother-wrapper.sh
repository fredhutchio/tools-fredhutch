#!/bin/bash

source $(dirname $0)/util.sh
source $1

SCRIPT_DIR="$(dirname $0)/cbrother_pipeline/code"

FLAGS=""
if [[ ${ALLOW_ANCIENT} == "TRUE" ]]; then
    FLAGS="--allow-ancient"
fi

python ${SCRIPT_DIR}/setup_cbrother.py ${FLAGS} ${ALIGNMENT} ${GENOTYPE_MAP} cbrother

# TODO: make this more slurmy
export SHELL="/bin/bash"
ls *.cmd | parallel -j 12 ${SCRIPT_DIR}'/run_cbrother.py {} {.}.phy cbrother.geno {.}.pp'

rm -f pproc.csv
for PPROC in *.pp.pproc; do
    SEQUENCE=$(echo ${PPROC} | awk -F. '{ print $2 }')
    IE_COP=$(grep 'number_ie_cop_gelman_rubin:' ${PPROC} | cut -d' ' -f2 | perl -p -e 's/\n//')
    PCP=$(grep 'number_pcp_gelman_rubin:' ${PPROC} | cut -d' ' -f2 | perl -p -e 's/\n//')
    echo "${SEQUENCE},${IE_COP},${PCP}" >> pproc.csv
done
sort < pproc.csv | sed '1isequence,number_ie_cop_gelman_rubin,number_pcp_gelman_rubin' | csvlook | a2ps - -o - | ps2pdfwr - pproc.pdf

pdftk cbrother.*.pdf pproc.pdf cat output ${REPORT}
