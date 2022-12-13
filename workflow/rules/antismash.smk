SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
ANTISMASH_FILEPATH = config.get("ANTISMASH_FILEPATH", "antismash/")
DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")


rule antismash:
    input:
        f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
    output:
        directory(f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}{{sample}}"),
    log:
        "logs/antismash_{sample}.log",
    benchmark:
        "benchmarks/antismash_{sample}.log"
    conda:
        "../envs/base_python.yaml"
    params:
        extra=" ".join(config.get("antismash", "")),
    threads: int(config.get("ANTISMASH-THREADS", 200))
    shell:
        "antismash {params.extra} "
        "-c CPUS {threads} "
        "--logfile {log} "
        " --output-dir {output} "
        "{input} "
