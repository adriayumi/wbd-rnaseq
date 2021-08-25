# conda environment: salmon

workdir: '/home/adriayumi/WBD_RNA-seq/05-Salmon/FA553_tcc/quantification/'

SAMPLES, = glob_wildcards('/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/bioC_samples/{sample}_L002_nonrRNA_fwd.fq.gz')

rule all:
    input:
        expand('{sample}_quant/quant.sf', sample=SAMPLES)

rule salmon:
    input:
        READS1 = expand('/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/bioC_samples/{{sample}}_L00{n}_nonrRNA_fwd.fq.gz', n=['2','3']),
        READS2 = expand('/home/adriayumi/WBD_RNA-seq/02.1-SortmeRNA/bioC_samples/{{sample}}_L00{n}_nonrRNA_rev.fq.gz', n=['2','3'])
    params:
        INDEX = '/home/adriayumi/WBD_RNA-seq/05-Salmon/FA553_tcc/salmon_index',
        dir = directory('{sample}_quant')
    output:
        '{sample}_quant/quant.sf'
    shell:
        'salmon quant -i {params.INDEX} -l ISR -1 {input.READS1} -2 {input.READS2} --validateMappings --gcBias --numGibbsSamples 20 -o {params.dir} -p 3'
