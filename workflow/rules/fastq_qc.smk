DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
TRIMMED_READS_FILEPATH = config.get("TRIMMED_READS_FILEPATH", "trimmed/")
FASTQC_FILEPATH = config.get("FASTQC_FILEPATH", "allfastqc/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)


rule fastq_qc:
    input:
        f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R{{read_n}}_val_{{read_n}}.fq.gz",
    output:
        html=report(
            f"{DEFAULT_DEST_FILEPATH}{FASTQC_FILEPATH}{{sample}}_R{{read_n}}.html",
            caption="report/fastq_qc_html.rst",
            category="Quality Control and Trimming",
            subcategory="{sample}",
        ),
        zip=f"{DEFAULT_DEST_FILEPATH}{FASTQC_FILEPATH}{{sample}}_R{{read_n}}_fastqc.zip",
    params:
        extra=" ".join(config.get("fastqc", "")),
    log:
        "logs/fastqc/{sample}_R{read_n}.log",
    conda:
        "../envs/generate_fastq_qc_statistics.yaml"
    threads: AVAILABLE_THREADS
    wrapper:
        "v1.12.1/bio/fastqc"
