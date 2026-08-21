#!/usr/bin/env bash

# ============================================================
# Script: genomes_download.sh
#
# Purpose:
# Download genome assemblies corresponding to the candidate
# duplicate sets identified in the previous filtering step.
# The script retrieves the GenBank FTP path for each GCA accession,
# downloads the genome sequence and MD5 checksum file, and stores
# the files according to their duplicate set.
#
# Input:
# A tab-delimited file containing duplicate set numbers and
# GenBank assembly accessions (GCA_*).
#
# Output:
# - Set wise folders:
#   * Genome assembly files (.fna.gz)
#   * md5checksums.txt
# - download_log.txt
#
# Dependencies:
# - NCBI Entrez Direct (EDirect)
# 
## Usage:
# bash genomes_download.sh
#
# ============================================================

logfile="download_log.txt" 
: > "$logfile"   # empty the log at start

FILE=input_files/sets_GenBank_IDs.tsv

for gca in `cut -f2 input_files/sets_GenBank_IDs.tsv`;
 do 

    # extract set ID
    set_num=$(grep $gca $FILE| cut -f1 | sed -e 's/__.*//g') 
     mkdir -p "$set_num"

    echo "Processing $gca into $set_num..." | tee -a "$logfile"

    # get FTP path 
    ftp_path=$(esearch -db assembly -query "$gca" \
        | esummary \
        | xtract -pattern DocumentSummary -element FtpPath_GenBank \
        | awk '{print $1; exit}')

    if [ -z "$ftp_path" ]; then
        echo "No FTP path for $gca" | tee -a "$logfile"
        continue
    fi

    fname=$(basename "$ftp_path")
    url="$ftp_path/${fname}_genomic.fna.gz"
    outfile="$set_num/${fname}_genomic.fna.gz"

    echo "Downloading from: $url" | tee -a "$logfile"

   curl -fsSL -o "$set_num/md5checksums.txt" "$ftp_path/md5checksums.txt" || {
    echo "Could not fetch md5checksums.txt" | tee -a "$logfile"
    continue
    }

    expected_md5=$(grep "${fname}_genomic.fna.gz" "$set_num/md5checksums.txt" | awk '{print $1}')



    if [ -z "$expected_md5" ]; then
        echo "No MD5 found for ${fname}_genomic.fna.gz" | tee -a "$logfile"
        continue
    fi

    curl -f -L -C - -o "$outfile" "$url"

    
    # Check gzip integrity
    if ! gzip -t "$outfile" 2>/dev/null; then
        echo "Corrupt gzip, retrying..." | tee -a "$logfile"
        rm -f "$outfile"
    curl -f -L -C - -o "$outfile" "$url"
   
    fi

    # Verify MD5
    actual_md5=$(md5sum "$outfile" | awk '{print $1}')

    if [ "$expected_md5" = "$actual_md5" ]; then
        echo "Verified $outfile (MD5 match)" | tee -a "$logfile"
        echo -e "$gca\t$set_num\tOK\t$expected_md5" >> "$logfile"
    else
        echo "MD5 mismatch for $outfile" | tee -a "$logfile"
        echo -e "$gca\t$set_num\tFAIL\tExpected:$expected_md5\tGot:$actual_md5" >> "$logfile"
        rm -f "$outfile"
    fi

done < $FILE
