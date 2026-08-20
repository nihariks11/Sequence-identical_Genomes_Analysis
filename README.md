# Sequence-identical_Genomes_Analysis
Public microbial genome repositories (NCBI) contain thousands of sequence-identical genome assemblies assigned to
different taxonomic lineages, potentially inflating microbial diversity and introducing bias into comparative genomics,
metagenomics, and pathogen surveillance. By systematically screening 729,559 NCBI prokaryotic genomes using
assembly metadata filtering followed by MD5 hash-based sequence validation, we identified 3,334 sets of completely
identical genome assemblies with taxonomic inconsistencies. We propose a simple redundancy-aware genome
submission workflow that combines assembly-level screening with cryptographic sequence identity checks to flag
identical submissions, harmonize metadata, and strengthen the accuracy, transparency, and reliability of public
genomic databases.

#### Step 1: Filtering based on assembly features: GC%, Genome Size and Number of Scaffolds (Filter 1)

###### Step 1a: Genome size information (in bp) extracted again

###### Step 1b: Finding duplicates based on accurate genome size and adding set wise counters


#### Step 2: Downloading genomes


#### Step 3: MD5 based comparison to identify sequence identical genomes (Filter 2)


#### Step 4: Taxonomic assignment and comparison


#### Step 5: RefSeq counterpart check


#### Step 6: Metadata retrieval of sequence identical genomes
