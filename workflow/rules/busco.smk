DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
SPADES_FILEPATH = config.get("SPADES_FILEPATH", "spades/")
BUSCO_FILEPATH = config.get("BUSCO_FILEPATH", "busco/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)

rule busco:
    input:
        f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}{{sample}}_spades/{{sample}}.fasta",
    output:
        out_dir=directory(f"{DEFAULT_DEST_FILEPATH}{BUSCO_FILEPATH}{{sample}}/txome_busco/prok"),
        dataset_dir=directory(f"{DEFAULT_DEST_FILEPATH}{BUSCO_FILEPATH}{{sample}}/resources/busco_downloads"),
    log:
        "logs/busco/{sample}.log",
    params:
        mode="genome",
        # optional parameters
        extra=" ".join(config.get("busco", "")),
    threads: AVAILABLE_THREADS
    wrapper:
        "v1.12.2/bio/busco" 