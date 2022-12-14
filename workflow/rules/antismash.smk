SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
ANTISMASH_FILEPATH = config.get("ANTISMASH_FILEPATH", "antismash/")
DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")

rule antismash:
    input:
        f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
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
        docker = config.get("ANTISMASH-DOCKER", "antismash/standalone:6.1.1")
    threads: int(config.get("ANTISMASH-THREADS", 200))
    shell:
        "bash workflow/scripts/run_antismash.sh "
        "{input} {output} {params.docker} "
        "--cpus {threads} "
        "{params.extra} "
        ">> {log} 2>&1 "
        