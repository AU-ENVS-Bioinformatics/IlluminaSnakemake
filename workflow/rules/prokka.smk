DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
PROKKA_FILEPATH = config.get("PROKKA_FILEPATH", "prokka/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)


rule prokka:
    input:
        f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
    output:
        out_dir=directory(f"{DEFAULT_DEST_FILEPATH}{PROKKA_FILEPATH}{{sample}}_prokka"),
        txt=report(
            f"{DEFAULT_DEST_FILEPATH}{PROKKA_FILEPATH}{{sample}}_prokka/{{sample}}.txt",
            caption="report/prokka_text.rst",
            category="Genome annotation",
            subcategory="{sample}",
        ),
        tsv=report(
            f"{DEFAULT_DEST_FILEPATH}{PROKKA_FILEPATH}{{sample}}_prokka/{{sample}}.tsv",
            caption="report/prokka_tsv.rst",
            category="Genome annotation",
            subcategory="{sample}",
        ),
    log:
        "logs/prokka/{sample}.log",
    conda:
        "../envs/annotate_bacterial_genome.yaml"
    params:
        extra=" ".join(config.get("prokka", "")),
    threads: AVAILABLE_THREADS
    shell:
        "prokka --outdir {output.out_dir} {params.extra} "
        "--cpus {threads} "
        "--prefix {wildcards.sample} --locustag {wildcards.sample} "
        "{input} >> {log} 2>&1"
