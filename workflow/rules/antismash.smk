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
    singularity:
        "docker://antismash/standalone:6.1.1"
    params:
        extra=" ".join(config.get("antismash", "")),
        outdir=lambda wildcards: f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}",
    threads: int(config.get("ANTISMASH-THREADS", 200))
    shell:
        "antismash --output-dir {output} "
        "--cpus {threads} "
        "{params.extra} "
        "{input}  "
        ">> {log} 2>&1 "

rule edit_gbk:
    input: 
        expand(
            f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}{{sample}}",
            sample = set(sample)
        )
    output: 
        expand(
            f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}edited_gbk/{{sample}}.gbk",
            sample = set(sample)
        )
    
    log: "logs/antismash/edited_gbk.log"
    conda:
        "../envs/base_python.yaml"
    script: "../scripts/edited_gbk.py"

rule bigscape:
    input:
        expand(
            f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}edited_gbk/{{sample}}.gbk",
            sample = set(sample)
        ),
    output:
        directory(f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}bigscape"),
    log:
        "logs/antismash/big_scape.log",
    benchmark:
        "benchmarks/antismash/big_scape.log"
    singularity:
        config.get("BIGSCAPE-SINGULARITY", "")
    params:
        extra=" ".join(config.get("bigscape", "")),
        indir=lambda wildcards: f"{DEFAULT_DEST_FILEPATH}{ANTISMASH_FILEPATH}edited_gbk",
    threads: int(config.get("BIGSCAPE-THREADS", 200))
    shell:
        "python /usr/src/BiG-SCAPE/bigscape.py "
        "-i {params.indir} -o {output} -c {threads} "
        "{params.extra} "
        ">> {log} 2>&1 " 