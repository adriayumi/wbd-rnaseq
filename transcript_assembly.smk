# conda environment: star
# Stringtie

workdir: '/home/adriayumi/WBD_RNA-seq/04-Stringtie/FA553_assembly'

SAMPLES, = glob_wildcards('/home/adriayumi/WBD_RNA-seq/03-STAR/Alignments/bioC_samples/{sample}_Aligned.sortedByCoord.out.bam')

rule all:
    input:
        expand('/home/adriayumi/WBD_RNA-seq/04-Stringtie/FA553_assembly/FA553/{sample}_mper.gtf', sample=SAMPLES),

rule stringtie:
    input:
        '/home/adriayumi/WBD_RNA-seq/03-STAR/Alignments/bioC_samples/{sample}_Aligned.sortedByCoord.out.bam'
    output:
        '/home/adriayumi/WBD_RNA-seq/04-Stringtie/FA553_assembly/{sample}.gtf'
    params:
        prefix = '{sample}.gtf'
    threads: 2
    shell:
        'stringtie {input} -G /home/adriayumi/WBD_RNA-seq/03-STAR/Genomes/Combined/combined_annotations.gff3 \
        --rf -p 2 \
        -o {params.prefix} \
        -f 0.05 -c 1.5 \
        -v '

rule divide:
    input:
        '/home/adriayumi/WBD_RNA-seq/04-Stringtie/FA553_assembly/{sample}.gtf'
    output:
        Mper = '/home/adriayumi/WBD_RNA-seq/04-Stringtie/FA553_assembly/FA553/{sample}_mper.gtf',
        Tcc = '/home/adriayumi/WBD_RNA-seq/04-Stringtie/FA553_assembly/tcc/{sample}_tcc.gtf'
    shell:
        'grep "Mper" {input} > {output.Mper} && grep -v "Mper" {input} > {output.Tcc}'
