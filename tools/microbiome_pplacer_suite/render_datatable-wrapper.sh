#!/bin/bash

source $(dirname $0)/util.sh
source $1

mkdir -p ${OUTPUT_DIR}

python $(dirname $0)/render_datatable.py \
    < ${INPUT} \
    > ${OUTPUT_DIR}/index.html

cat <<EOF > ${OUTPUT}
<!DOCTYPE HTML>
<html lang="en-US">
  <head/>
  <body>
    <a href="index.html">Generated table</a>
  </body>
</html>
EOF
