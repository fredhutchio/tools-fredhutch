#!/bin/bash

source $(dirname $0)/util.sh
source $1

RDP_SEQS="/shared/silo_researcher/Matsen_F/MatsenGrp/micro_refset/rdp/10_31/tax_filter/filtered/rdp_10_31.filter.fasta"
RDP_SEQINFO="/shared/silo_researcher/Matsen_F/MatsenGrp/micro_refset/rdp/10_31/tax_filter/filtered/rdp_10_31.filter.seq_info.csv"

sqlite3 -csv -header ${CLASS_DB} <<EOF > usearch_meta.csv
SELECT pn.name, CAST(pn.mass AS INT) count, tax_id, tax_name, taxa.rank
  FROM multiclass_concat
    JOIN taxa USING (tax_id)
    JOIN placement_names pn USING (placement_id, name)
    WHERE want_rank = 'species';
EOF

romp -v usearch_clusters \
    --usearch-quietly \
    --query-group tax_id \
    --query-duplication count \
    --database-name seqname \
    --database-group tax_id \
    ${INPUT_SEQS} \
    usearch_meta.csv \
    ${RDP_SEQS} \
    ${RDP_SEQINFO} \
    ${USEARCH_HITS} \
    ${USEARCH_GROUPS}
