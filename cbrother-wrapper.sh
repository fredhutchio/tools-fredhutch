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
ls *.cmd | parallel -j 12 "${SCRIPT_DIR}/run_cbrother.py --length ${LENGTH} {} {.}.phy cbrother.geno {.}.pp"

${SCRIPT_DIR}/diagnostic_summary.sh *.pp.pproc | a2ps --stdin="Diagnostic summary" - -o - | ps2pdfwr - diag.pdf
pdftk cbrother.*.pdf diag.pdf cat output ${REPORT}

for PROFILE in *.pp.profile; do
    SEQUENCE=$(echo ${PROFILE} | awk -F. '{ print $2 }')
    ${SCRIPT_DIR}/csvify_profile.R ${PROFILE} ${SEQUENCE}.profile.csv
done

csvstack -n sequence --filenames *.profile.csv > merged_profiles.csv
${SCRIPT_DIR}/clean_merged_profiles.R merged_profiles.csv ${GENOTYPE_PROFILE}
