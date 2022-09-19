DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
TRIMMED_READS_FILEPATH = config.get("TRIMMED_READS_FILEPATH", "trimmed/")
SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
QUAST_FILEPATH = config.get("QUAST_FILEPATH", "quast/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)


rule quast:
    input:
        fasta=f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
        R1=f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R1_val_1.fq.gz",
        R2=f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R2_val_2.fq.gz",
    output:
        outdir=directory(f"{DEFAULT_DEST_FILEPATH}{QUAST_FILEPATH}{{sample}}"),
        report_txt=report(
            f"{DEFAULT_DEST_FILEPATH}{QUAST_FILEPATH}{{sample}}/report.txt",
            caption="report/quast_txt.rst",
            category="Genome assembly",
            subcategory="{sample}",
        ),
        report_html=report(
            f"{DEFAULT_DEST_FILEPATH}{QUAST_FILEPATH}{{sample}}/report.html",
            caption="report/quast_html.rst",
            category="Genome assembly",
            subcategory="{sample}",
        ),
    log:
        "logs/quast/{sample}.log",
    conda:
        "../envs/generate_quality_assessment_genome_assemblies.yaml"
    params:
        extra=" ".join(config.get("quast", "")),
    threads: AVAILABLE_THREADS
    shell:
        "quast {params.extra} "
        "--threads {threads} "
        "--pe1 {input.R1} --pe2 {input.R2} "
        "-o {output.outdir} "
        "{input.fasta} "
        ">> {log} 2>&1 "
