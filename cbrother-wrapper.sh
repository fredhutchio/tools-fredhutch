#!/bin/bash

source $(dirname $0)/util.sh
source $1

export PERL_LOCAL_LIB_ROOT="/home/matsengrp/perl-local";
export PERL_MB_OPT="--install_base /home/matsengrp/perl-local";
export PERL_MM_OPT="INSTALL_BASE=/home/matsengrp/perl-local";
export PERL5LIB="/home/matsengrp/perl-local/lib/perl5/x86_64-linux-gnu-thread-multi:/home/matsengrp/perl-local/lib/perl5";

SCRIPT_DIR="$(dirname $0)/cbrother_pipeline/code"

FLAGS=""
if [[ ${ALLOW_ANCIENT} == "TRUE" ]]; then
    FLAGS="${FLAGS} --allow-ancient"
fi

if [[ ${CONSENSUS} == "TRUE" ]]; then
    FLAGS="${FLAGS} --consensus"
fi

if [[ -r ${PARENT_TREE} ]]; then
    FLAGS="${FLAGS} --parent-tree ${PARENT_TREE}"
fi

python ${SCRIPT_DIR}/setup_cbrother.py ${FLAGS} ${ALIGNMENT} ${GENOTYPE_MAP} cbrother

#cat *.cmd

# TODO: make this more slurmy
export SHELL="/bin/bash"
ls *.cmd | parallel -j 12 "${SCRIPT_DIR}/run_cbrother.py --cores 1 --length ${LENGTH} {} {.}.phy cbrother.geno {.}.pp"

PDFS=""
for PPROC in *.pp.pproc; do
    PREFIX=${PPROC%%.pp.pproc}
    ${SCRIPT_DIR}/diagnostic_summary.sh ${PPROC} | a2ps -1 --stdin="Diagnostic summary" - -o - | ps2pdfwr - ${PREFIX}.diag.pdf
    PDFS="${PDFS} ${PREFIX}.pp.pdf ${PREFIX}.diag.pdf"
done

pdftk ${PDFS} cat output ${REPORT}

for PROFILE in *.pp.profile; do
    SEQUENCE=$(echo ${PROFILE} | awk -F. '{ print $2 }')
    ${SCRIPT_DIR}/csvify_profile.R ${PROFILE} ${SEQUENCE}.profile.csv
done

PROFILES=$(find . -name '*.profile.csv' -print0)
if [[ ${#PROFILES} > 1 ]]; then
    csvstack -n sequence --filenames *.profile.csv > merged_profiles.csv
else
    cp ${PROFILES} merged_profiles.csv
fi

${SCRIPT_DIR}/clean_merged_profiles.R merged_profiles.csv ${GENOTYPE_PROFILE}
