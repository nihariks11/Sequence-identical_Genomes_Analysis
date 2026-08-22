# ============================================================
# Script: refseq_counterpart_mapping.R
#
# Purpose:
# Map GenBank assembly accessions to their corresponding RefSeq
# assembly information using the NCBI assembly summary data.
#
# The script performs left joins between the GenBank assembly
# accession datasets generated at different stages of the
# filtering workflow and the NCBI assembly summary containing
# RefSeq counterpart information.
#
# Input:
# - GenBank_IDs_from_prok.txt
#   GenBank assembly accession information from the initial
#   prokaryotic genome dataset.
#
# - GenBank_ID_org_RefSeq_from_assembly_summary.txt
#   NCBI assembly summary containing GenBank and corresponding
#   RefSeq assembly information.
#
# - GenBank_IDs_after_first_filter.txt
#   Dataset obtained after the first filtering step.
#
# - GenBank_IDs_after_second_filter.txt
#   Dataset obtained after the second filtering step.
#
# Output:
# - RefSeq_leftjoin.xlsx
#   RefSeq information mapped to the initial GenBank dataset.
#
# - first_filter_RefSeq_mapped.xlsx
#   RefSeq information mapped to the dataset after the first
#   filtering step.
#
# - second_filter_RefSeq_mapped.xlsx
#   RefSeq information mapped to the dataset after the second
#   filtering step.
#
# Usage:
#   Rscript refseq_counterpart_mapping.R
# ==============================

library(tidyverse)
library(writexl)

dat <- read.csv("GenBank_IDs_from_prok.txt", T,sep ="\t")
refseq_from_assemb_sum <- read.csv("GenBank_ID_org_RefSeq_from_assembly_summary.txt", T, sep="\t")

first_filt <- read.csv("GenBank_IDs_after_first_filter.txt", T,sep ="\t")
second_filt <- read.csv("GenBank_IDs_after_second_filter.txt", T,sep ="\t")

lj <- left_join(dat,refseq_from_assemb_sum,by="assembly_accession")
first <- left_join(first_filt,refseq_from_assemb_sum,by="assembly_accession")
second <- left_join(second_filt,refseq_from_assemb_sum,by="assembly_accession")

write_xlsx(lj,"RefSeq_leftjoin.xlsx")
write_xlsx(first,"first_filter_RefSeq_mapped.xlsx")
write_xlsx(second,"second_filter_RefSeq_mapped.xlsx")
