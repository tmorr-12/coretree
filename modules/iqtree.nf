process IQTREE {
    // https://iqtree.github.io/
    cpus 96

    container "quay.io/biocontainers/iqtree:3.1.4--h8471819_0"

    publishDir "${params.outdir}"

    input:
    path(phylip)

    output:
    path("core_tree.treefile")
    tuple val('iqtree'), eval("iqtree -version | grep -oE '[0-9]+[.][0-9]+[.][0-9]+' | head -n1"), topic: versions

    script:
    """
    iqtree \\
        --prefix core_tree \\
        -s ${phylip} \\
        -m MFP+ASC \\
        -T AUTO \\
        -ntmax ${task.cpus} \\
        -B 1000
    """

    stub:
    """
    touch core_tree.treefile
    """
}