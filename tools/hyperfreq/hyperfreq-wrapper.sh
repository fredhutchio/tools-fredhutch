#!/bin/bash

source $(dirname $0)/util.sh
source $1

CONTEXTS="$(echo ${CONTEXTS} | sed 's/,/ /g')"

hyperfreq analyze ${ALIGNMENT} -p ${CONTEXTS} -s ${SIG_LEVEL} ${REFERENCE}
cp hm_analysis.call.csv ${CALLS}
cp hm_analysis.sites.csv ${SITES}

hyperfreq split ${ALIGNMENT} ${SITES}
cp hm_split.pos.fasta ${HM_POS_ALN}
cp hm_split.neg.fasta ${HM_NEG_ALN}
