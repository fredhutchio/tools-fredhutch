#!/bin/bash

source $(dirname $0)/util.sh
source $1

csvjoin -c 'specimen' ${GROUP_BY_SPECIMEN} ${METADATA} > ${DECORATED_GROUP_BY_SPECIMEN}
