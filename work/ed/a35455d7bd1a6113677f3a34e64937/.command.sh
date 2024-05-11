#!/bin/bash -ue
mkdir fastqc_ERR5743893_logs
fastqc -o fastqc_ERR5743893_logs -f fastq -q ERR5743893_1.fastq ERR5743893_2.fastq
