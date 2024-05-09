nextflow.enable.dsl = 2

/*
* Parameters Definition
*/

params.reads = "$baseDir/data/*_{1,2}.fastq"
params.reference_file = "$baseDir/data/MN908947.fasta"
params.multiqc = "$baseDir/multiqc"
params.index_dir = "$baseDir/ref"
params.outdir = "results"

log.info """\
        V A R C A L L - N F  P I P E L I N E
        ===================================
        Adapted by Adebowale
        ===================================
        reference    : ${params.reference_file}
        reads        : ${params.reads}
        outdir       : ${params.outdir}
        """
        .stripIndent(true)

// INDEXING

process BWA_INDEX {
    input:
    path genome

    output:
    path genome

    script:
    """
    bwa index ${genome}
    """
}

/*
Quality Control
*/
process FASTQC {
    cpus 4

    tag "FASTQC on $sample_id"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs"

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -t ${task.cpus} -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """
}

// MULTIQC
process MULTIQC {
    cpus 4

    publishDir params.outdir, mode:'copy'
    
    input:
    path '*'

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}

// MAPPING
process MAPPING {
    conda 'bwa samtools'
    cpus 4
    publishDir 'results/mapped', mode: 'copy'

    input:
    path index_dir
    val reference_file
    tuple val(sample_id), path(reads)
    //path(reference_file)

    output:
    path "*"

    script:
    """
    bwa mem -t "${task.cpus}" ${index_dir}/${reference_file} ${reads} | samtools view -bS - > ${sample_id.}.bam
    """
}

workflow {
    // Channel declaration
    Channel
        .fromFilePairs(params.reads, checkIfExists: true)
        .set {reads_pairs_ch}
    //
    index_ch = BWA_INDEX(params.index_dir)
    fastqc_ch = FASTQC(reads_pairs_ch)
    multiqc_ch = MULTIQC(fastqc_ch.collect())
    mapping_ch = MAPPING(index_ch, ref_ch, reads_pairs_ch)

    BWA_INDEX.out.view()
}