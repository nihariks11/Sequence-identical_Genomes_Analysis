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

**Output:**
`Step_2_Downloading_genomes/output_files/`
<br> Output folders for SETS 1-5 have been presented here as an example.
<br> **Total SET folders:** 5603

---

## Step 3: MD5-based Comparison to Identify Sequence-identical Genomes (Filter 2)

---

## Step 4: Taxonomic Assignment and Comparison

---

## Step 5: RefSeq Counterpart Check

---

## Step 6: Metadata Retrieval of Sequence-identical Genomes




#### Step 6: Metadata retrieval of sequence identical genomes
