#!/bin/bash

source $(dirname $0)/util.sh
source $1

CONTEXTS="$(echo ${CONTEXTS} | sed 's/,/ /g')"

hyperfreq analyze ${ALIGNMENT} -p ${CONTEXTS} -s ${SIG_LEVEL} ${REFERENCE}
cp hm_analysis.call.csv ${CALLS}
cp hm_analysis.sites.csv ${SITES}
cp hm_analysis.log ${LOG}
