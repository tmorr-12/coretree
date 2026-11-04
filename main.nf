#!/usr/bin/env nextflow

include { PANAROO } from './modules/panaroo.nf'
include { SNP_SITES } from './modules/snp_sites.nf'
include { IQTREE } from './modules/iqtree.nf'

workflow {

    if (params.help) {
        log.info """
Usage:
    nextflow run main.nf -profile <standard|laptop> --gffs <path/to/gffs_dir>
"""
        exit 0
    }

    gffs = Channel.fromPath("${params.gffs}/*.gff3", checkIfExists: true).collect()

    PANAROO(gffs)
    core_aln_ch = PANAROO.out.core_aln

    SNP_SITES(core_aln_ch)
    core_snps_ch = SNP_SITES.out.core_snps

    IQTREE(core_snps_ch)

    channel.topic('versions')
        .unique()
        .map { tool, version -> "${tool}\t${version}" }
        .collectFile(
            storeDir: "${params.outdir}/pipeline-info",
            name: 'software_versions.tsv',
            newLine: true,
            sort: true
        )

}