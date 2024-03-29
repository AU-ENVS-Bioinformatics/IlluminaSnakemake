DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
TRIMMED_READS_FILEPATH = config.get("TRIMMED_READS_FILEPATH", "trimmed/")
SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)


rule spades:
    input:
        R1=f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R1_val_1.fq.gz",
        R2=f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R2_val_2.fq.gz",
    output:
        outdir=directory(f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades"),
        contigs=protected(
            f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta"
        ),
        report=report(
            f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/params.txt",
            caption="report/spades_params.rst",
            category="Genome assembly",
            subcategory="{sample}",
        ),
    params:
        extra=" ".join(config.get("spades", "")),
    log:
        "logs/spades/{sample}.log",
    container:
        "docker://staphb/spades:3.15.5"
    threads: AVAILABLE_THREADS
    shell:
        "spades.py {params.extra} "
        "--threads {threads} "
        "-o {output.outdir} "
        "-1 {input.R1} -2 {input.R2} "
        ">> {log} 2>&1 "
        "&& mv {output.outdir}/contigs.fasta {output.contigs} "
