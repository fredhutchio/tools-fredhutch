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
            LINK="${BASENAME%%.*}.${REQ_EXT}"
            ln -s ${FILE} ${LINK}
            FILE="${LINK}"
        fi
        OUTPUT="${OUTPUT} ${FILE}"
    done

    echo ${OUTPUT}
}
