#!/bin/bash -ue
bwa-mem2 mem -t 1 /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta ERR5405022_1.fastq ERR5405022_2.fastq | samtools sort -@ 20 -o ERR5405022.sorted.bam - && samtools index ERR5405022.sorted.bam
