#!/bin/bash -ue
bwa-mem2 mem -t 1 /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta SRR13500958_1.fastq SRR13500958_2.fastq | samtools sort -@ 20 -o SRR13500958.sorted.bam - && samtools index SRR13500958.sorted.bam
