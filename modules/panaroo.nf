process PANAROO {
    // https://github.com/gtonkinhill/panaroo
    cpus 32

    container "quay.io/biocontainers/panaroo:1.8.0--pyhdfd78af_0"

    publishDir "${params.outdir}"

    input:
    path(gffs, stageAs:"gffs/*")

    output:
    path("core_gene_alignment.aln"), emit: core_aln
    tuple val('panaroo'), eval("panaroo --version | sed 's/^.*panaroo //'"), topic: versions

    script:
    """
    mkdir -p panaroo_out
    
    panaroo \\
        -i gffs/*.gff3 \\
        -o panaroo_out/ \\
        --clean-mode sensitive \\
        -a core \\
        --aligner mafft \\
        --remove-invalid-genes \\
        --core_threshold 0.99 \\
        -t ${task.cpus}

    mv panaroo_out/core_gene_alignment.aln core_gene_alignment.aln
    """

    stub:
    """
    touch core_gene_alignment.aln
    """
}