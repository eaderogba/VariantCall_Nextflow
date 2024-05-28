# Genome Analysis Pipeline Project

## Overview

### SARS-CoV-2 WGS Analysis using nextflow
This repository contains the workflow for the whole-genome sequencing (WGS) analysis of SARS-CoV-2 using a pipeline written in nextflow. The analysis is based on a benchmark dataset, which includes 16 samples from CDC-defined Variants of Interest/Variants of Concern (VOI/VOC) lineages.

### Dataset Description
The dataset is a validated lineage-calling benchmark set, designed for the study of VOI/VOC lineages of SARS-CoV-2. Detailed information about the dataset can be found here.

### Reference Sequence
The analysis utilizes the Wuhan-1 reference sequence (MN908947.fa) for mapping the sequence data.

The pipeline includes steps for reference genome indexing, quality control, mapping, and variant calling.

#### Reference Genome Indexing
The reference genome is indexed using BWA-MEM2

#### Quality Control
Quality control is performed on the raw sequencing reads using FastQC, and the results are aggregated using MultiQC.

#### Mapping and Sorting
Sequencing reads are mapped to the reference genome using BWA-MEM2, and the resulting alignments are sorted using SAMtools.

#### Variant Calling
Variants are called using FreeBayes, and the results are compressed and indexed using bgzip and tabix.

#### Output Files
The pipeline generates several output files, including:

Quality control reports (fastqc and multiqc outputs)
Sorted BAM files (.sorted.bam and .sorted.bam.bai)
Variant call files (.vcf.gz, .vcf.gz.tbi, .tsv, and _stats.txt)

#### Installation and Usage
To run this pipeline, you will need to have the following tools installed:

BWA-MEM2
FastQC
MultiQC
SAMtools
FreeBayes
Nextflow

### Profiles
This pipeline can be executed in different environments using either Conda or Docker. The configuration is specified in the nextflow.config file.

Conda Profile
To use the Conda profile, ensure you have Conda installed. The required dependencies will be managed automatically.
#### Command:
nextflow run main.nf -profile conda

Docker Profile
To use the Docker profile, ensure you have Docker installed. The required Docker images will be pulled and used for each process.
#### Command:
nextflow run main.nf -profile docker

