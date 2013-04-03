#!/bin/bash

set -eux

source $(dirname $0)/util.sh

PPLACER_DEFAULT_ARGS="-p --inform-prior --prior-lower 0.01 --map-identity"

REFPKG=$1
QUERY_SEQS=$2
PLACED_SEQS=$3

QUERY_SEQS=$(extify fasta ${QUERY_SEQS})

pplacer ${PPLACER_DEFAULT_ARGS} -c ${REFPKG} ${QUERY_SEQS} -o ${PLACED_SEQS}
