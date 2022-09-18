DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
BUSCO_FILEPATH = config.get("BUSCO_FILEPATH", "busco/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)


rule busco:
    input:
        f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
    output:
        out_dir=directory(f"{DEFAULT_DEST_FILEPATH}{BUSCO_FILEPATH}{{sample}}"),
    log:
        "logs/busco/{sample}.log",
    params:
        extra=" ".join(config.get("busco", "")),
        download_path=f"{DEFAULT_DEST_FILEPATH}{BUSCO_FILEPATH}busco_downloads",
    conda:
        "../envs/busco.yaml"
    threads: AVAILABLE_THREADS
    shell:
        "busco -i {input} "
        "-o {output.out_dir} "
        "-m genome "
        "{params.extra} "
        "-c {threads} "
        ">> {log} 2>&1 "
