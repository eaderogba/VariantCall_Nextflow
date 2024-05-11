#!/bin/bash -ue
freebayes -f /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta ERR5556343.sorted.bam | bgzip -c > ERR5556343.vcf.gz && tabix -p vcf ERR5556343.vcf.gz && bcftools query -H -f '%CHROM	%POS	%ID	%REF	%ALT[	%GT]
' ERR5556343.vcf.gz > ERR5556343.tsv && bcftools stats ERR5556343.vcf.gz > ERR5556343_stats.txt
