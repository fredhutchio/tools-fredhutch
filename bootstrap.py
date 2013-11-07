#!/usr/bin/env python

from __future__ import print_function
import csv
import sys
import os
import argparse

def warning(*objs):
    print("WARNING: ", *objs, file=sys.stderr)

def main(arguments):

    parser = argparse.ArgumentParser(arguments, description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('infile', help = "CSV input",
                        type = argparse.FileType('r'), default = sys.stdin)
    parser.add_argument('--plate', help = "plate number", type = int, required = True)
    parser.add_argument('--zone', help = "zone number", type = int, required = True)
    parser.add_argument('--barcodes', help = "name of barcodes file",
                        type = argparse.FileType('w'), default = 'barcodes.csv')
    parser.add_argument('--labels', help = "name of labels file",
                        type = argparse.FileType('w'), default = 'labels.csv')
    parser.add_argument('--metadata', help = "name of metadata template file",
                        type = argparse.FileType('w'), default = 'metadata.csv')

    args = parser.parse_args(arguments)

    label_key = 'sampleid'
    primer_key = 'reverse'
    barcode_key = 'barcode'
    zone_key = 'zone'

    fstr = "p{}z{}{}"

    reader = csv.DictReader(sys.stdin)

    barcodes = csv.writer(args.barcodes)
    labels = csv.writer(args.labels)
    metadata = csv.writer(args.metadata)

    barcodes.writerow(['stub', 'barcode'])
    labels.writerow(['specimen', 'label'])
    metadata.writerow(['specimen', 'plate', 'zone', 'label', 'primer'])

    seen_labels = {}
    seen_primers = {}

    # TODO: add checks for duplicates, empty fields, etc., and bail if something goes wrong
    for i, d in enumerate(reader):
        if not all (k in d for k in (label_key, primer_key, barcode_key)):
            return "Expected columns not found"

        if zone_key in d and d[zone_key] != str(args.zone):
            continue

        label = d[label_key]
        primer = d[primer_key]
        barcode = d[barcode_key]
        zone = args.zone

        if not all((label, primer, barcode)):
            # only print a warning if at least one of the fields is non-empty
            if any((label, primer, barcode)):
                warning("Missing required field on row {}, skipping".format(i+2))
            continue

        if label in seen_labels:
            return "Duplicate label '{}' found on rows {} and {}".format(label, seen_labels[label]+2, i+2)

        if primer in seen_primers:
            return "Duplicate primer '{}' found on rows {} and {}".format(primer, seen_primers[primer]+2, i+2)

        seen_labels[label] = i
        seen_primers[primer] = i

        specimen = fstr.format(args.plate, zone, primer.strip().lower().replace('-',''))
        barcodes.writerow([specimen, barcode])
        labels.writerow([specimen, label])
        metadata.writerow([specimen, args.plate, zone, label, primer])

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
