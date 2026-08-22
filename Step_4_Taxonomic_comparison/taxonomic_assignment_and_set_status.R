# ============================================================
# Script: taxonomic_assignment_and_set_status.R
#
# Purpose:
# Combine the genome duplicate-set information with MD5-based
# sequence identity results and NCBI taxonomic information.
#
# The script first reads the assembly/duplicate-set data,
# MD5-based set status information, and NCBI ranked lineage
# taxonomy. The datasets are then joined using SetID and TaxID
# to assign the corresponding sequence identity status and
# taxonomic classification to each genome.
#
# Input:
# - duplicates_full_genome_size.xlsx
#   Assembly/duplicate-set information generated from Step 1.
#
# - rankedlineage_edited.dmp
#   NCBI ranked lineage taxonomy file but separators were edited 
#   to remove tabs and keep only "|". 
#
# - md5_results_only_SET_status.txt
#   MD5-based sequence identity results containing SetID status.
#
# Output:
#   TaxID_Set_Status_Mapped.xlsx
#
# Usage:
#   Rscript taxonomic_assignment_and_set_status.R
#
# ============================================================

library(tidyverse)
library(readxl)
library(writexl)

data <- read_xlsx("input_files/duplicates_full_genome_size.xlsx") 
tax_dmp <- read.csv("input_files/rankedlineage_edited.dmp", sep = "|", quote="", F)
set_status<- read.csv("input_files/md5_results_only_SET_status.txt", sep = "\t")

colnames(tax_dmp) <- c('TaxID','Organism_name','C3','Genus','Family','Order','Class','Phylum','C9','Superkingdom','C11')

lj1 <- left_join(data,set_status,by="SetID")
lj2 <- left_join(lj1,tax_dmp,by="TaxID")

write_xlsx(lj2,"output_files/TaxID_Set_Status_Mapped.xlsx")

