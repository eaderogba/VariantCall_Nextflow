#!/bin/bash
set -e
set -u

sample_id=${1}
reads=${2}

mkdir fastqc_${sample_id}_logs
/home/eaderogba279/anaconda3/bin/fastqc fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
