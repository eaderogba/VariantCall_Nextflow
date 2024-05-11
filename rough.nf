// FREEBAYES FOR VARIANT CALLING
process FREEBAYES_VARIANT_CALLING {
    publishDir 'results/variant_file', mode: 'copy'

    input:
    tuple val(sample_id), path(bam_file)
    val genome
    //val index_dir

    output:
    path "${sample_id}.vcf"

    script:
    """
    freebayes -f ${genome} -b ${bam_file} > ${sample_id}.vcf
    """
}