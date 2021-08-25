#Sortmerna v.4.3.2

workdir: '/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/'

SAMPLES, = glob_wildcards('/home/adriayumi/WBD_RNA-seq/02-adapter_trimming/{sample}_R1_001_trimmed.fastq.gz')

rule all:
    input:
        expand('{sample}_nonrRNA_fwd.fq.gz', sample=SAMPLES),
        expand('{sample}_nonrRNA_rev.fq.gz', sample=SAMPLES)

rule sortmerna:
    input:
        R1 = '/home/adriayumi/WBD_RNA-seq/02-adapter_trimming/{sample}_R1_001_trimmed.fastq.gz',
        R2 = '/home/adriayumi/WBD_RNA-seq/02-adapter_trimming/{sample}_R2_001_trimmed.fastq.gz',
    params:
        other = '{sample}_nonrRNA',
        outdir = '{sample}_out/',
        log = '{sample}.log'
    output:
        '{sample}_nonrRNA_fwd.fq.gz',
        '{sample}_nonrRNA_rev.fq.gz'
    shell:
        'sortmerna --ref reference_db/silva-arc-16s-id95.fasta \
        --ref reference_db/silva-arc-23s-id98.fasta \
        --ref reference_db/silva-bac-16s-id90.fasta \
        --ref reference_db/silva-bac-23s-id98.fasta  \
        --ref reference_db/silva-euk-18s-id95.fasta  \
        --ref reference_db/silva-euk-28s-id98.fasta  \
        --ref reference_db/rfam-5s-database-id98.fasta \
        --ref reference_db/rfam-5.8s-database-id98.fasta \
        --reads {input.R1} --reads {input.R2} \
        --paired_out --out2 --other {params.other}  \
        --workdir {params.outdir}  --num_alignments 1 \
        --fastx --threads 12 -v > {params.log}'
