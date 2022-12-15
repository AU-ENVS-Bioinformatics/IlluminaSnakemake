from pathlib import Path

PROKKA_FILEPATH = config.get("PROKKA_FILEPATH", "prokka/")
ANTISMASH_FILEPATH = config.get("ANTISMASH_FILEPATH", "antismash/")
DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")


rule run_antismash:
    input:
        f"{DEFAULT_DEST_FILEPATH}{PROKKA_FILEPATH}{{sample}}_prokka/{{sample}}.gbk",
    output:
        directory(f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}{{sample}}"),
    log:
        "logs/antismash/{sample}.log",
    benchmark:
        "benchmarks/antismash/{sample}.log"
    conda:
        "../envs/base_python.yaml"
    params:
        extra=" ".join(config.get("antismash", "")),
        docker=config.get("ANTISMASH-DOCKER", "antismash/standalone:6.1.1"),
        outdir=lambda wildcards: f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}",
    threads: int(config.get("ANTISMASH-THREADS", 200))
    shell:
        "bash workflow/scripts/run_antismash.sh "
        "{input} {params.outdir} {params.docker} "
        "--cpus {threads} "
        "{params.extra} "
        ">> {log} 2>&1 "
