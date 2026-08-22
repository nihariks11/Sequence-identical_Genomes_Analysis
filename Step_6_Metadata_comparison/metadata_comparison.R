#!/usr/bin/env Rscript

# ============================================================
# Script: metadata_comparison_by_set.R
#
# Purpose:
# Compare selected genome metadata within each sequence-identical
# genome set (SetID) to identify metadata that are the same,
# different, or missing between genome assemblies.
#
# For each SetID, the script examines the selected metadata
# fields and determines whether each field contains:
# - Missing information
# - The same value across all genomes in the set
# - Different values between genomes in the set
#
# Input:
# - Metadata_input_for_comparison.txt
#
# Output:
# - metadata_comparison_by_set.txt
#   Tab-delimited file containing the set-wise comparison of
#   metadata for each sequence-identical genome set.
#
#
# Usage:
#   Rscript metadata_comparison_by_set.R
#
# ============================================================

library(tidyverse)
df <- read.csv("Metadata_input_for_comparison.txt",sep = "\t",TRUE)

#view(DATA)
library(dplyr)

cols <- c("Assembly", "BioSample", "Organism", "Submitter", "SeqTech",
          "SubmissionDate", "SubmissionYear" ,"IsolationSource", "GeoLocName",
          "CollectionDate", "Host", "RefSeq_Accession", "RefSeq_Present")

comparison <- df %>%
  group_by(SetID) %>%
  summarise(
    across(
      all_of(cols),
      ~{
        vals <- unique(as.character(.))
        vals <- vals[!is.na(vals) & vals != ""]
        
        if(length(vals) == 0){
          "Missing"
        } else if(length(vals) == 1){
          paste0("Same: ", vals)
        } else {
          paste0("Different: ", paste(vals, collapse = " | "))
        }
      }
    ),
    .groups = "drop"
  )

write.table(comparison,
            "metadata_comparison_by_set.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)

View(comparison)