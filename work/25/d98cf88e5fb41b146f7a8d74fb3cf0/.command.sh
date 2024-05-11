#!/bin/bash -ue
mkdir fastqc_ERR5405022_logs
fastqc -o fastqc_ERR5405022_logs -f fastq -q ERR5405022_1.fastq ERR5405022_2.fastq
