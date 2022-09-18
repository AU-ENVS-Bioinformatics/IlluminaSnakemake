SAMPLES_TO_COMPARE_FILEPATH = config.get("SAMPLES_TO_COMPARE_FILEPATH", "")
DREP_FILEPATH = config.get("DREP_FILEPATH", "dRep/")
CHECKM_FILEPATH = config.get("CHECKM_FILEPATH", "checkM/")
AVAILABLE_THREADS = int(workflow.cores * 0.75)

COMPARE_DIR = get_final_outdir_to_compare(SAMPLES_TO_COMPARE_FILEPATH)
FILES2COMPARE = get_files_to_compare()


rule compare:
    input:
        f"{DEFAULT_DEST_FILEPATH}{DREP_FILEPATH}{COMPARE_DIR}",
        f"{DEFAULT_DEST_FILEPATH}{CHECKM_FILEPATH}{COMPARE_DIR}",


rule dRep:
    input:
        FILES2COMPARE,
    log:
        f"logs/compare/dRep_{COMPARE_DIR}",
    conda:
        "../envs/compare.yaml"
    output:
        dRep=directory(f"{DEFAULT_DEST_FILEPATH}{DREP_FILEPATH}{COMPARE_DIR}"),
    params:
        extra=" ".join(config.get("dRep", "")),
    threads: AVAILABLE_THREADS
    shell:
        "dRep compare  {output} "
        "{params.extra} "
        "-p {threads} "
        "-g {input} "
        ">> {log} 2>&1 "


rule checkM:
    input:
        FILES2COMPARE,
    log:
        f"logs/compare/checkM_{COMPARE_DIR}",
    conda:
        "../envs/compare.yaml"
    output:
        tmp=directory(f"{DEFAULT_DEST_FILEPATH}{CHECKM_FILEPATH}{COMPARE_DIR}_tmp"),
        checkM=directory(f"{DEFAULT_DEST_FILEPATH}{CHECKM_FILEPATH}{COMPARE_DIR}"),
    params:
        extra=" ".join(config.get("checkM", "")),
    threads: AVAILABLE_THREADS
    shell:
        "mkdir -p {output.tmp} && "
        "cp {input} {output.tmp} && "
        "checkm lineage_wf {output.tmp} {output.checkM} "
        "{params.extra} "
        "fasta "
        "-t {threads} "
        ">> {log} 2>&1 "
