#!/bin/bash

extify() {
    local REQ_EXT=$1
    shift

    local OUTPUT=""
    local FILE
    for FILE in $*; do
        local BASENAME=$(basename ${FILE})
        local EXT=${BASENAME##*.}
        if [[ ${EXT} != ${REQ_EXT} ]]; then
            local LINK="${BASENAME%%.*}.${REQ_EXT}"
            if [[ ! -f ${LINK} ]]; then
                ln -s ${FILE} ${LINK}
            fi
            FILE="${LINK}"
        fi
        OUTPUT="${OUTPUT} ${FILE}"
    done

    echo ${OUTPUT}
}

set -ex

MATSENGRP="/home/matsengrp/local"
export PATH="${MATSENGRP}/bin:${PATH}"
export LD_LIBRARY_PATH="${MATSENGRP}/lib:${MATSENGRP}/lib64:${MATSENGRP}/lib64/R/lib:${LD_LIBRARY_PATH}"
export PERL5LIB="${MATSENGRP}/lib/perl5:${PERL5LIB}"

set -u
