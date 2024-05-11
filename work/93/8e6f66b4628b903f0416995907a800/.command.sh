#!/bin/bash -ue
freebayes -f /home/eaderogba279/Bionformatics_Projects/VariantCall_Nextflow/reference/MN908947.fasta SRR13500958.sorted.bam | bgzip -c > SRR13500958.vcf.gz && tabix -p vcf SRR13500958.vcf.gz && bcftools query -H -f '%CHROM	%POS	%ID	%REF	%ALT[	%GT]
' SRR13500958.vcf.gz > SRR13500958.tsv && bcftools stats SRR13500958.vcf.gz > SRR13500958_stats.txt
