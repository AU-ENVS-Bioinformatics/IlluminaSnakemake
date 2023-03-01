DEFAULT_DEST_FILEPATH = config.get("DEFAULT_DEST_FILEPATH", "results/")
BARRNAP_FILEPATH = config.get("BARRNAP_FILEPATH", "barrnap/")


rule find_16s:
    input:
        fasta=report(
            f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_rrna.fa",
            caption="report/barrnap_gff.rst",
            category="Genome annotation",
            subcategory="{sample}",
        ),
        gff=report(
            f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_rrna.gff",
            caption="report/barrnap_gff.rst",
            category="Genome annotation",
            subcategory="{sample}",
        ),
    output:
        fasta=f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_filtered_rrna.fa",
        gff=f"{DEFAULT_DEST_FILEPATH}{BARRNAP_FILEPATH}{{sample}}_filtered_rrna.gff",
    params:
        config.get("minumun_16s_allowed", 900),
    container: 
        "docker://nanozoo/biopython:1.74--b03961c"
    log:
        "logs/barrnap/{sample}_filtered.log",
    script:
        "../scripts/filter_16S_from_barrnap.py"
