DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
BARRNAP_FILEPATH = config.get("BARRNAP_FILEPATH", "barrnap/")

rule find_16s:
    input:
        fasta = f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_rrna.fa",
        gff = f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_rrna.gff",
    output:
        fasta = f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_filtered_rrna.fa",
        gff = f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_filtered_rrna.gff",
    params:
        config.get("minumun_16s_allowed", 900)
    conda:
        "../envs/base_python.yaml"
    log:
        "logs/barrnap/{sample}_filtered.log"    
    script:
        "../scripts/filter_16S_from_barrnap.py"