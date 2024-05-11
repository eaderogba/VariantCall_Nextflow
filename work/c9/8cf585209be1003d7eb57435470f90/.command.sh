#!/bin/bash -ue
freebayes -f /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta ERR5181310.sorted.bam | bgzip -c > ERR5181310.vcf.gz && tabix -p vcf ERR5181310.vcf.gz && bcftools query -H -f '%CHROM	%POS	%ID	%REF	%ALT[	%GT]
' ERR5181310.vcf.gz > ERR5181310.tsv && bcftools stats ERR5181310.vcf.gz > ERR5181310_stats.txt
