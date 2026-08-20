# ============================================================
# Script: full_genome_size_02.sh
#
# Purpose:
# Use NCBI Entrez Direct to retrieve the full genome sizes of the assemblies that have been identified as duplicates in the previous step. 
#
# Input:
# GenBank assembly IDs (GCA_*) from duplicates.txt     
#
# Output:
#  Full_genome_sizes.tsv
#
# Usage:
#   bash full_genome_size_02.sh
#
# ============================================================


for i in $(cat only_GCA_IDs.txt); do  
    size=$(timeout 60s esearch -db assembly -query "$i" \
        | esummary \
        | xtract -pattern Stat -if @category -equals total_length -element . \
	| sed -e 's/^.* "//g' -e 's/"$//g' )

    if [[ -n "$size" ]]; then
        echo -e "$i\t$size"
    else
        echo -e "$i\tNA"
    fi
done > Full_genome_sizes.tsv
