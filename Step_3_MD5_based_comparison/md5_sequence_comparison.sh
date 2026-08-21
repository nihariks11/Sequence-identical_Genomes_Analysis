#!/usr/bin/env bash

# ============================================================
# Purpose:
# Compare genome sequences within each candidate duplicate set
# using MD5 checksums.
#
# The downloaded .gz genome files are first uncompressed.
# For each .fna file, FASTA headers are removed and the complete
# nucleotide sequence is concatenated before calculating an MD5
# checksum. The MD5 checksums are then compared within each set
# to determine whether the genome sequences are identical.
#
# Input: Genome assembly files (.fna.gz) organized into set-wise
# directories.
#
# Output: md5_results.txt
# Reports whether all genome sequences within each set are
# identical or differ.
#
# Usage:
# bash md5_sequence_comparison.sh
#
# ============================================================


for dir in */; do
    cd "$dir" || continue

    # Unzip only .gz files
    if ls *.gz >/dev/null 2>&1; then
        gunzip -f *.gz
    fi

    # Collect .fna files
    fna_files=(*.fna)
    file_count=${#fna_files[@]}

    if [ "$file_count" -lt 2 ]; then
        echo "${dir%/}: Not enough .fna files to compare"
    else
        uniq_count=$(for f in "${fna_files[@]}"; do
            grep -v "^>" "$f" | tr -d '\n' | md5sum | awk '{print $1}'
        done | sort -u | wc -l)

        if [ "$uniq_count" -eq 1 ]; then
            echo "${dir%/}: ${fna_files[*]} : All files are identical"
        else
            echo "${dir%/}: ${fna_files[*]} : Files differ (ignoring headers)"
        fi
    fi

    cd ..
done > md5_results.txt 
