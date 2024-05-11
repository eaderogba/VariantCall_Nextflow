#!/bin/bash -ue
freebayes -f /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta ERR5405022.sorted.bam | bgzip -c > ERR5405022.vcf.gz && tabix -p vcf ERR5405022.vcf.gz && bcftools query -H -f '%CHROM	%POS	%ID	%REF	%ALT[	%GT]
' ERR5405022.vcf.gz > ERR5405022.tsv && bcftools stats ERR5405022.vcf.gz > ERR5405022_stats.txt
