#!/bin/bash

source $(dirname $0)/util.sh
source $1

QUERY_SEQS=$(extify fasta ${QUERY_SEQS})
PPLACER_DEFAULT_ARGS="-j ${GALAXY_SLOTS:-4} -p --inform-prior --prior-lower 0.01 --map-identity"

pplacer \
    ${PPLACER_DEFAULT_ARGS} \
    -c ${REFPKG} \
    -o ${PLACED_SEQS} \
    ${QUERY_SEQS}
