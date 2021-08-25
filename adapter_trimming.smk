# conda environment: qc-processing

workdir: './'

SAMPLES, = glob_wildcards('/home/adriayumi/WBD_RNA-seq/00-raw_reads/{sample}_R1_001.fastq.gz')

rule all:
    input:
        'RNAseq_trimming_report.html'

rule cutadapt:
    input:
        R1 = '/home/adriayumi/WBD_RNA-seq/00-raw_reads/{sample}_R1_001.fastq.gz',
        R2 = '/home/adriayumi/WBD_RNA-seq/00-raw_reads/{sample}_R2_001.fastq.gz'
    output:
        R1 = '{sample}_R1_001_trimmed.fastq.gz',
        R2 = '{sample}_R2_001_trimmed.fastq.gz'
    log:
        'cutadapt_logs/{sample}_001_trimmed.log'
    threads: 6
    shell:
        'cutadapt \
        -j {threads} \
        --no-indels -e 0.1 -o 8 -m 30 \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        -o {output.R1} -p {output.R2} \
        {input.R1} {input.R2} > {log}'

rule fastqc:
    input:
        expand('{{sample}}_R{n}_001_trimmed.fastq.gz', n=['1','2'])
    output:
        temp(expand('{{sample}}_R{n}_001_trimmed_fastqc.html', n=['1', '2'])),
        temp(expand('{{sample}}_R{n}_001_trimmed_fastqc.zip', n=['1', '2']))
    params:
        output_directory = './'
    shell:
        'fastqc -o {params.output_directory} {input}'

rule multiqc:
    input:
        expand('{sample}_R{n}_001_trimmed_fastqc.html', sample=SAMPLES, n=['1', '2']),
        expand('{sample}_R{n}_001_trimmed_fastqc.zip', sample=SAMPLES, n=['1', '2']),
        expand('cutadapt_logs/{sample}_001_trimmed.log', sample=SAMPLES)
    output:
        'RNAseq_trimming_report.html'
    params:
        title = 'RNA-seq samples adapter trimming report',
        filename = 'RNAseq_trimming_report'
    shell:
        'multiqc --interactive -o ./ -i "{params.title}" -n {params.filename} {input}'
