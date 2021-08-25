# conda environment: star

workdir: './'

SAMPLES, = glob_wildcards('/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/bioC_samples/{sample}_nonrRNA_fwd.fq.gz')

rule all:
    input:
        expand('Alignments/{sample}_Aligned.sortedByCoord.out.bam', sample=SAMPLES),
        expand('Alignments/{sample}_SJ.out.tab', sample=SAMPLES),
        expand('Alignments/{sample}_Log.final.out', sample=SAMPLES)

rule star:
    input:
        R1 = '/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/bioC_samples/{sample}_nonrRNA_fwd.fq.gz',
        R2 = '/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/bioC_samples/{sample}_nonrRNA_rev.fq.gz', 
    output:
        'Alignments/{sample}_Aligned.sortedByCoord.out.bam',
        'Alignments/{sample}_SJ.out.tab',
        'Alignments/{sample}_Log.final.out'
    params:
        prefix = './Alignments/{sample}_',
    threads: 6
    shell:
        'STAR --genomeDir /home/adriayumi/WBD_RNA-seq/03-STAR/Index_bioC \
        --runThreadN 6 \
        --readFilesIn {input.R1} {input.R2} \
        --outFileNamePrefix {params.prefix} \
        --readFilesCommand gunzip -c \
        --outSAMtype BAM SortedByCoordinate '
