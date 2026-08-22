#!/usr/bin/env bash

# ============================================================
# Script: assembly_features_duplicates_01.sh
#
# Purpose:
# Identify records that have identical
# values for full genome size, GC%, and Scaffolds.
#
# Input: full_genome_size_mapped.tsv 
# (This input file can be created by mapping the full genome size
# obtained from step 1a to the duplicates.txt file based on the 
# GenBank Accessions column)
#   
# Output: duplicates_full_genome_size.tsv
#
# Usage:
#   bash duplicates_full_genome_size_03.sh
#
# ============================================================

awk '
BEGIN { FS=OFS="\t" }
NR==1 {
 
    for (i=1; i<=NF; i++) {
        if ($i=="Actual.Size") col1=i
        else if ($i=="GC.") col2=i
        else if ($i=="Scaffolds") col3=i
    }
    print $0, "SetID"   # add header for set label
    next
}
{
    key = $col1 OFS $col2 OFS $col3
    count[key]++
    lines[key] = lines[key] ORS $0
}
END {
    set_counter = 1
    for (k in count) {
        if (count[k] > 1) {
            split(lines[k], arr, ORS)
            file_counter = 1
            for (i in arr)
                if (arr[i] != "")
                    print arr[i], "SET_" set_counter "__file" file_counter++
            set_counter++
        }
    }
}' input_files/full_genome_size_mapped.tsv > output_files/duplicates_full_genome_size.tsv

