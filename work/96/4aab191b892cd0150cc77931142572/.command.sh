#!/bin/bash -ue
freebayes -f /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta ERR5743893.sorted.bam | bgzip -c > ERR5743893.vcf.gz && tabix -p vcf ERR5743893.vcf.gz && bcftools query -H -f '%CHROM	%POS	%ID	%REF	%ALT[	%GT]
' ERR5743893.vcf.gz > ERR5743893.tsv && bcftools stats ERR5743893.vcf.gz > ERR5743893_stats.txt
