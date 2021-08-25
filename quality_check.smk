# Conda environment: qc-processing
# Initial quality assessment of raw reads

workdir: '/home/adriayumi/WBD_RNA-seq/01-quality_check'

SAMPLES, = glob_wildcards('/home/adriayumi/WBD_RNA-seq/00-raw_reads/{sample}.fastq.gz')

rule all:
    input:
        'multiqc/WBD_RNAseq_fastqc_report.html'

rule fastqc:
    input:
        expand('/home/adriayumi/WBD_RNA-seq/00-raw_reads/{sample}.fastq.gz', sample=SAMPLES)
    output:
        temp(expand('{sample}_fastqc.html', sample=SAMPLES)),
        temp(expand('{sample}_fastqc.zip', sample=SAMPLES))
    params:
        output_directory = './'
    shell:
        'fastqc -o {params.output_directory} {input}'

rule multiqc:
    input:
        expand('{sample}_fastqc.html', sample=SAMPLES),
        expand('{sample}_fastqc.zip', sample=SAMPLES)
    output:
        'multiqc/WBD_RNAseq_fastqc_report.html'
    params:
        title = 'WBD mRNA-seq samples FastQC report',
        filename = 'WBD_RNAseq_fastqc_report',
        output_directory = 'multiqc'
    shell:
        'multiqc --interactive -o {params.output_directory} -i "{params.title}" -n {params.filename} {input}'
