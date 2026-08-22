#!/usr/bin/env bash

# ============================================================
# Script: assembly_features_duplicates_01.sh
#
# Purpose:
# Identify records in a tab-delimited file that have identical
# values for Size (Mb), GC%, and Scaffolds.
#
# Input:
#   prokaryotes.txt (wget https://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt)

#
# Output:
#   duplicates.tsv
#
# Usage:
#   ./assembly_features_duplicates_01.sh
#
# ============================================================

awk '
BEGIN { FS=OFS="\t" }
NR==1 {

    for (i=1; i<=NF; i++) {
        if ($i=="Size (Mb)") col1=i
        else if ($i=="GC%") col2=i
        else if ($i=="Scaffolds") col3=i
    }
    print
    next
}
{
# Build key from 3 columns
    key = $col1 OFS $col2 OFS $col3
    count[key]++
    lines[key] = lines[key] ORS $0
}
END {
    for (k in count)
        if (count[k] > 1)
            printf "%s", lines[k]
}' prokaryotes.txt > output_files/duplicates.tsv

