# ============================================================
# Script: set_wise_taxonomy_comparison.R
#
# Purpose:
# Compare the taxonomic classifications of genomes within each
# sequence-identical genome set and identify the taxonomic rank
# at which differences occur.
#
# For each SetID, the script compares taxonomy sequentially from
# Superkingdom to Strain. The first taxonomic level showing more
# than one distinct value is reported as the level of difference.
#
# Missing, empty, or NA taxonomic values are treated as
# incomplete taxonomy. If a set contains both incomplete taxonomy
# and other taxonomic values at a given level, the difference is
# reported as "Incomplete taxonomy".
#
# Input:
# - identical_set_status.tsv
#   Tab-delimited file containing the sequence-identical genome
#   sets (SetID) and their taxonomic classifications.
#
# Output:
# - Set_wise_tax_level_comparsion_git.xlsx
#   Excel file containing one row per SetID, the identified
#   taxonomic level of difference, and the corresponding values
#   collapsed for the other columns.
#
# Usage:
#   Rscript set_wise_taxonomy_comparison.R
#
# ============================================================


library(dplyr)
library(writexl)
library(tidyverse)

df <- read.csv("identical_set_status.tsv", 
               header = TRUE, sep = "\t", stringsAsFactors = FALSE)

tax_cols <- c("Superkingdom", "Kingdom", "Phylum", "Class", "Order",
              "Family", "Genus", "Species","Strain")

find_diff_level <- function(group) {
  for (col in tax_cols) {
    values <- unique(group[[col]])
    values[is.na(values) | values == "NA" | values == ""] <- "incomplete taxonomy"
    
    if (length(values) > 1) {
      if ("incomplete taxonomy" %in% values) {
        return("Incomplete taxonomy")
      } else {
        return(col)
      }
    }
  }
  return("No difference")
}

collapse_vals <- function(x) {
  unique_vals <- unique(x)
  unique_vals[is.na(unique_vals) | unique_vals == "NA" | unique_vals == ""] <- "incomplete"
  paste(unique(unique_vals), collapse = "; ")
}

differences <- df %>%
  group_by(SetID) %>%
  summarise(
    Differences = find_diff_level(cur_data()),
    across(everything(), collapse_vals),  # collapse all other columns
    .groups = "drop"
  )

print(differences, n = Inf)
#view(differences)


write_xlsx(differences,"Set_wise_tax_level_comparsion.xlsx")
