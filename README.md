# Sequence-identical_Genomes_Analysis
Public microbial genome repositories (NCBI) contain thousands of sequence-identical genome assemblies assigned to
different taxonomic lineages, potentially inflating microbial diversity and introducing bias into comparative genomics,
metagenomics, and pathogen surveillance. By systematically screening 729,559 NCBI prokaryotic genomes using
assembly metadata filtering followed by MD5 hash-based sequence validation, we identified 3,334 sets of completely
identical genome assemblies with taxonomic inconsistencies. We propose a simple redundancy-aware genome
submission workflow that combines assembly-level screening with cryptographic sequence identity checks to flag
identical submissions, harmonize metadata, and strengthen the accuracy, transparency, and reliability of public
genomic databases.

#### Step 1: Filtering based on assembly features (Filter 1)
This is the initial filtering step to find sets of 2 or more genomes that have identical genome features including GC%, Genome Size and Number of Scaffolds. 
<br><br> **SCRIPT**: assembly_features_duplicates_01.sh
<br> **INPUT**: The input for this is the data for all prokaryotes on NCBI including 729559 genomes and can be downloaded from https://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt.   
**OUTPUT**: Step_1_Assembly_feature_filtering/output_files/duplicates.txt

###### Step 1a: Genome size information (in bp) extracted again
The accurate genome size in base pairs was required because the prokaryotes.txt file has size mentioned in Mb which could be a rounded off figure. The genome size was obtained again from NCBI using the Entrez Direct toolkit.  
<br> **SCRIPT**: full_genome_size_02.sh
<br> **INPUT**: Step_1_Assembly_feature_filtering/output_files/GenBank_IDs.txt
<br> **OUTPUT**: Step_1_Assembly_feature_filtering/output_files/Full_genome_sizes.tsv

###### Step 1b: Finding duplicates based on accurate genome size and adding set wise counters


#### Step 2: Downloading genomes


#### Step 3: MD5 based comparison to identify sequence identical genomes (Filter 2)


#### Step 4: Taxonomic assignment and comparison


#### Step 5: RefSeq counterpart check


#### Step 6: Metadata retrieval of sequence identical genomes
