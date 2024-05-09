params.ref = "$baseDir/reference/MN908947.fasta"
params.index_dir = "$baseDir/index_dir"
params.reads = "$baseDir/data/*_{1,2}.fastq"
params.qc_report = "$baseDir/fastqc_report"
params.multiqc_report = "$baseDir/multiqc_report"

// Reference Genome Indexing using BWA
process BWA_INDEX {

    publishDir("${params.index_dir}"), mode: 'copy'

    input:
    path genome

    output:
    path "*"

    script:
    """
    bwa index $genome
    """
}

// Run Quality Control using FastQC
process FASTQC {
    publishDir("${params.qc_report}", mode: 'copy')

    tag "FASTQC on $sample_id"
    cpus 4

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
    cpus 4

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

// Mapping using BWA
process MAPPING {
    publishDir 'results/mapped', mode: 'copy'

    tag "MAPPING on $sample_id"

    input:
    path index_dir
    val ref
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.bam") 

    script:
    """
    bwa mem -t ${task.cpus} ${ref} ${reads} | samtools view -Sb - > "${sample_id}.bam"
    """
}

workflow {
    // Channel Declarations
    index_ch = Channel.fromPath(params.index_dir)
    reference_ch = Channel.of(params.ref)
    reads_pairs_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    // Index the reference genome
    BWA_INDEX(reference_ch)

    // Run FastQC on reads
    fastqc_ch = FASTQC(reads_pairs_ch)

    // Aggregate FastQC results using MULTIQC
    MULTIQC(fastqc_ch.collect())

    // Perform mapping using MAPPING process
    mapping = MAPPING(index_ch, reference_ch, reads_pairs_ch)

    // View the output of the mapping process
    mapping.view()
}