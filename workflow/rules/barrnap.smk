DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
BARRNAP_FILEPATH = config.get("BARRNAP_FILEPATH", "barrnap/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)


rule barrnap:
    input:
        f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
    output:
        fasta=report(
            f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_rrna.fa",
            caption="report/barrnap_fa.rst",
            category="Genome annotation",
            subcategory="{sample}",
        ),
        gff=report(
            f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_rrna.gff",
            caption="report/barrnap_gff.rst",
            category="Genome annotation",
            subcategory="{sample}",
        ),
    log:
        "logs/barrnap/{sample}.log",
    conda:
        "../envs/barrnap.yaml"
    shell:
        "barrnap -o {output.fasta} < {input} > {output.gff} "
        "2> {log}"
