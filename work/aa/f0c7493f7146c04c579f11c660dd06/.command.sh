#!/bin/bash -ue
bwa-mem2 mem -t 1 /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta ERR5743893_1.fastq ERR5743893_2.fastq | samtools sort -@ 20 -o ERR5743893.sorted.bam - && samtools index ERR5743893.sorted.bam
