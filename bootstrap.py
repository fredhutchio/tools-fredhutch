#!/usr/bin/env python

"""
Create a mapping of samples to barcodes from sample information.

Usage: in2csv sample-info.xls | ./make_barcodes.py - <plate number>
"""

import csv
import sys
import os
import argparse

def main(arguments):

    parser = argparse.ArgumentParser(arguments, description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('infile', help = "CSV input",
                        type = argparse.FileType('r'), default = sys.stdin)
    parser.add_argument('--plate', help = "plate number", type = int, required = True)
    parser.add_argument('--barcodes', help = "name of barcodes file",
                        type = argparse.FileType('w'), default = 'barcodes.csv')
    parser.add_argument('--labels', help = "name of labels file",
                        type = argparse.FileType('w'), default = 'labels.csv')
    parser.add_argument('--metadata', help = "name of metadata template file",
                        type = argparse.FileType('w'), default = 'metadata.csv')

    args = parser.parse_args(arguments)

    label_key = 'label'
    primer_key = 'primer'
    barcode_key = 'barcode'
    zone_key = 'zone'

    fstr = 'j{}{}'

    reader = csv.DictReader(sys.stdin)

    barcodes = csv.writer(args.barcodes)
    labels = csv.writer(args.labels)
    metadata = csv.writer(args.metadata)

    barcodes.writerow(['stub', 'barcode'])
    labels.writerow(['specimen', 'label'])
    metadata.writerow(['specimen', 'plate', 'label', 'primer'])

    seen_labels = {}
    seen_primers = {}

    # TODO: add checks for duplicates, empty fields, etc., and bail if something goes wrong
    for i, d in enumerate(reader):
        if not all (k in d for k in (label_key, primer_key, barcode_key)):
            return "Expected columns not found"

        if zone_key in d:
            return "bootstrap.py can't handle multi-zone sample information files yet, sorry"

        label = d[label_key]
        primer = d[primer_key]
        barcode = d[barcode_key]

        if label in seen_labels:
            return "Duplicate label '{0}' found on rows {1} and {2}".format(label, seen_labels[label]+2, i+2)

        if primer in seen_primers:
            return "Duplicate primer '{0}' found on rows {1} and {2}".format(primer, seen_primers[primer]+2, i+2)

        seen_labels[label] = i
        seen_primers[primer] = i

        specimen = fstr.format(args.plate, primer.strip().lower().replace('-',''))
        barcodes.writerow([specimen, barcode])
        labels.writerow([specimen, label])
        metadata.writerow([specimen, args.plate, label, primer])

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
