#!/usr/bin/env bash

# ============================================================
# Script: metadata_extraction.sh
#
# Purpose:
# Retrieve metadata for sequence-identical genome assemblies
# identified in the previous analysis step using the NCBI
# Datasets command-line tool.
#
# The script queries NCBI for each genome accession and extracts
# selected assembly and BioSample metadata using jq.
#
# Metadata retrieved:
# - Assembly accession
# - BioSample accession
# - Organism
# - Submitter
# - Sequencing technology
# - Submission date
# - Isolation source
# - Geographic location
# - Collection date
# - Host
#
# Input:
# - GenBank_IDs_filter2.txt
#   List of genome assembly accessions corresponding to the
#   sequence-identical genomes.
#
# Output:
# - metadata.tsv
#   Tab-delimited file containing the selected metadata for
#   each sequence-identical genome assembly.
#
# Dependencies:
# - NCBI Datasets CLI
# - jq
#
# Usage:
#   bash metadata_extraction.sh
#
# ============================================================

echo -e "Assembly\tBioSample\tOrganism\tSubmitter\tSeqTech\tSubmissionDate\tIsolationSource\tGeoLocName\tCollectionDate\tHost" > metadata.tsv

while read acc; do

datasets summary genome accession "$acc" \
| jq -r '
.reports[0] |
[
.current_accession,
.assembly_info.biosample.accession,
.organism.organism_name,
.assembly_info.submitter,
.assembly_info.sequencing_tech,
.assembly_info.biosample.submission_date,
.assembly_info.biosample.isolation_source,
.assembly_info.biosample.geo_loc_name,
.assembly_info.biosample.collection_date,
.assembly_info.biosample.host
]
| @tsv'

done < GenBank_IDs_Filter2.txt >> metadata.tsv
