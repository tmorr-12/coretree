process SNP_SITES {
    // https://github.com/sanger-pathogens/snp-sites

    container "quay.io/biocontainers/snp-sites:2.5.1--h577a1d6_7"

    publishDir "${params.outdir}"

    input:
    path(core_aln)

    output:
    path("core_snps.phylip"), emit: core_snps
    tuple val('snpsites'), eval("snp-sites -V | sed 's/snp-sites //'"), topic: versions

    script:
    """
    snp-sites \\
        -o core_snps \\
        -v \\
        -p \\
        -m \\
        ${core_aln}
    """

    stub:
    """
    touch core_snps.phylip
    """
}