#!/bin/bash -ue
mkdir fastqc_SRR13500958_logs
fastqc -o fastqc_SRR13500958_logs -f fastq -q SRR13500958_1.fastq SRR13500958_2.fastq
