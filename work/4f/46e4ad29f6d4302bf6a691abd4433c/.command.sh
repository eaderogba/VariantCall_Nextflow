#!/bin/bash -ue
mkdir fastqc_ERR5181310_logs
fastqc -o fastqc_ERR5181310_logs -f fastq -q ERR5181310_1.fastq ERR5181310_2.fastq
