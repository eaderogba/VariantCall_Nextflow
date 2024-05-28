# Genome Analysis Pipeline Project

This project showcases a comprehensive genome analysis pipeline (written in nextflow) using various bioinformatics tool. The pipeline includes steps for reference genome indexing, quality control, mapping, and variant calling.

## Overview

### Reference Genome Indexing
The reference genome is indexed using BWA-MEM2

### Quality Control
Quality control is performed on the raw sequencing reads using FastQC, and the results are aggregated using MultiQC.

### Mapping and Sorting
Sequencing reads are mapped to the reference genome using BWA-MEM2, and the resulting alignments are sorted using SAMtools.

### Variant Calling
Variants are called using FreeBayes, and the results are compressed and indexed using bgzip and tabix.

### Output Files
The pipeline generates several output files, including:

Quality control reports (fastqc and multiqc outputs)
Sorted BAM files (.sorted.bam and .sorted.bam.bai)
Variant call files (.vcf.gz, .vcf.gz.tbi, .tsv, and _stats.txt)

### Installation and Usage
To run this pipeline, you will need to have the following tools installed:

BWA-MEM2
FastQC
MultiQC
SAMtools
FreeBayes
Nextflow
