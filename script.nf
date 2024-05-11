params.genome = "$baseDir/reference/MN908947.fasta"
params.index_dir = "$baseDir/index_dir"
params.reads = "$baseDir/data/*_{1,2}.fastq"
params.qc_report = "$baseDir/fastqc_report"
params.multiqc_report = "$baseDir/multiqc_report"
params.sorted_bam = "$baseDir/results/mapped/sorted/"
params.variant_call = "$baseDir/results/variant_call/"

// Reference Genome Indexing using BWA
process BWA_INDEX {

    publishDir("${params.index_dir}"), mode: 'copy'

    input:
    path genome

    output:
    path "*"

    script:
    """
    bwa-mem2 index $genome
    """
}

// Run Quality Control using FastQC
process FASTQC {
    publishDir("${params.qc_report}", mode: 'copy')

    tag "FASTQC on $sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs"

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """
}

process MULTIQC {
    publishDir ("${params.multiqc_report}", mode: 'copy')
    
    input:
    path '*'

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}

// Mapping and Sorting using BWA and SAMTOOLS
process MAPPING {
    publishDir ("${params.sorted_bam}"), mode: 'copy'

    tag "MAPPING on $sample_id"

    input:
    tuple val(sample_id), path(reads)
    val genome
    val index_dir

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam")

    script:
    """
    bwa-mem2 mem -t ${task.cpus} ${genome} ${reads} | samtools sort -@ 20 -o ${sample_id}.sorted.bam - && samtools index ${sample_id}.sorted.bam
    """
}

// FREEBAYES FOR VARIANT CALLING
process FREEBAYES_VARIANT_CALLING {
    publishDir "${params.variant_call}", mode: 'copy'

    input:
    val genome
    tuple val(sample_id), path(sorted_bam)

    output:
    path "${sample_id}.vcf.gz", emit: vcf
    path "${sample_id}.vcf.gz.tbi", emit: vcf_index
    path "${sample_id}.tsv", emit: tsv
    path "${sample_id}_stats.txt", emit: vcf_txt


    script:
    """
    freebayes -f ${genome} ${sorted_bam} | bgzip -c > ${sample_id}.vcf.gz && tabix -p vcf ${sample_id}.vcf.gz && bcftools query -H -f '%CHROM\t%POS\t%ID\t%REF\t%ALT[\t%GT]\n' ${sample_id}.vcf.gz > ${sample_id}.tsv && bcftools stats ${sample_id}.vcf.gz > ${sample_id}_stats.txt
    """
}

workflow {
    // Channel Declarations
    index_ch = Channel.fromPath(params.index_dir).first()
    genome_ch = Channel.fromPath(params.genome, checkIfExists: true).first()
    reads_pairs_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    sorted_bam_ch = Channel.fromPath(params.sorted_bam).first()

    // Index the reference genome
    BWA_INDEX(genome_ch)

    // Run FastQC on reads
    fastqc_ch = FASTQC(reads_pairs_ch)

    // Aggregate FastQC results using MULTIQC
    MULTIQC(fastqc_ch.collect())

    // Perform mapping using MAPPING process
    mapping = MAPPING(reads_pairs_ch, genome_ch, index_ch.collect())

    // Perform variant calling
    FREEBAYES_VARIANT_CALLING(genome_ch, mapping)
}