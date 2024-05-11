#!/bin/bash -ue
mkdir fastqc_ERR5556343_logs
fastqc -o fastqc_ERR5556343_logs -f fastq -q ERR5556343_1.fastq ERR5556343_2.fastq
