# Sequence-identical Genomes Analysis

Public microbial genome repositories (NCBI) contain thousands of sequence-identical genome assemblies assigned to different taxonomic lineages, potentially inflating microbial diversity and introducing bias into comparative genomics, metagenomics, and pathogen surveillance. By systematically screening **729,559 NCBI prokaryotic genomes** using assembly metadata filtering followed by MD5 hash-based sequence validation, we identified **3,334 sets of completely identical genome assemblies with taxonomic inconsistencies**. We propose a simple redundancy-aware genome submission workflow that combines assembly-level screening with cryptographic sequence identity checks to flag identical submissions, harmonize metadata, and strengthen the accuracy, transparency, and reliability of public genomic databases.

---

## Step 1: Filtering Based on Assembly Features (Filter 1)

This is the initial filtering step to find sets of **2 or more genomes** that have identical genome features, including **GC%, Genome Size and Number of Scaffolds**.

**Script:** `assembly_features_duplicates_01.sh`

**Input:**
The input for this is the data for all prokaryotes on NCBI, including **729,559 genomes**, and can be downloaded from:
https://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt

**Output:** `Step_1_Assembly_feature_filtering/output_files/duplicates.txt`

---

### Step 1a: Genome Size Information (in bp) Extracted Again

The accurate genome size in base pairs was required because the `prokaryotes.txt` file has size mentioned in Mb, which could be a rounded-off figure. The genome size was obtained again from NCBI using the **Entrez Direct toolkit**.

**Script:** `full_genome_size_02.sh`

**Input:** `Step_1_Assembly_feature_filtering/input_files/GenBank_IDs.txt`
**Number of IDs:** 14,271

**Output:** `Step_1_Assembly_feature_filtering/output_files/Full_genome_sizes.tsv`

---

### Step 1b: Finding duplicates based on accurate genome size and adding set wise counters

Similar as above, this step finds sets of **2 or more genomes** that have identical GC%, **Full Genome Size** and Number of Scaffolds.
The duplicates here are being identified using accurate genome size in bp and the script also groups genomes into sets and adds counters. 

**Script:** `duplicates_full_genome_size_03.sh`

**Input:** `Step_1_Assembly_feature_filtering/input_files/full_genome_size_mapped.tsv`

**Output:** `Step_1_Assembly_feature_filtering/output_files/duplicates_full_genome_size.tsv`
**Number of genomes:** 11,878


---

## Step 2: Downloading Genomes
11,878 genomes from the first filtered output were downloaded in their respective set wise folders from NCBI. The `mdchecksums.txt` file was also downloaded for each genome from NCBI to verify the integrity of the downloaded files.

**Script:** `genomes_download.sh`

**Input:** `Step_2_Downloading_genomes/input_files/sets_GenBank_IDs.tsv`

**Output:** `Step_2_Downloading_genomes/output_files/`
<br> Output folders for SETS 1-5 have been presented here as an example.
<br> **Total SET folders:** 5603 (all folders have not been uploaded)

---

## Step 3: MD5-based Comparison to Identify Sequence-identical Genomes (Filter 2)
MD5 checksum based sequence comparison was performed after concatenating removing the fasta headers and concatenating the sequence of each genome in each set by removing line breaks. This is the second filter which actually tells if the sequences within the set are identical. 

**Script:** `Step_3_MD5_based_comparison/md5_sequence_comparison.sh`

**Input:** Set wise directories created based on **Filter 1**. 
Example directories: `Step_2_Downloading_genomes/output_files/`

**Output:** `Step_3_MD5_based_comparison/output_files/md5_results.txt`

---

## Step 4: Taxonomic Assignment and Comparison

### Step 4a: Assigning NCBI taxonomy and mapping set status

**Script:** `Step_4_Taxonomic_comparison/Taxonomic_assignment_and_set_status.R`

**Input:** 
1. `Step_4_Taxonomic_comparison/input_files/rankedlineage_edited.dmp` 
The Taxdmp folder was downloaded on 25/08/2025 from `https://ftp.ncbi.nih.gov/pub/taxonomy/`. The The Ranked Lineage file was utilized and its separator was edited to remove tabs and retain only "|".
2. `Step_4_Taxonomic_comparison/input_files/duplicates_full_genome_size.xlsx`. This file was derived from Step 1.
3. `Step_4_Taxonomic_comparison/input_files/md5_results_only_SET_status.txt`. This file was derived from Step 3.

**Output:** `Step_4_Taxonomic_comparison/output_files/TaxID_Set_Status_Mapped.xlsx`

---

### Step 4b: Set wise taxonomy comparison

Sequence-identical genome sets i.e., **6754 genomes assigned to 3334 sets** were filtered out from the md5 comparsion results (Step3) and the taxonomic rank at which differences occured were identified.

**Script:** `Step_4_Taxonomic_comparison/set_wise_taxonomy_comparison.R`

**Input:**`Step_4_Taxonomic_comparison/input_files/identical_set_status.tsv` 
The input file was created after some manual edits on MS Excel:
1. to filter out the sequence identical data
2. create the species and strain level taxonomy columns per genome by splitting the organism name - because the ranked lineage data from NCBI provides classification until Genus level only 

**Output:**`Step_4_Taxonomic_comparison/output_files/Set_wise_tax_level_comparsion.xlsx` 

---

## Step 5: RefSeq Counterpart Check

---

## Step 6: Metadata Retrieval of Sequence-identical Genomes


