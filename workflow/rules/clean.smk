rule clean_dry:
    output:
        f"{DEFAULT_DEST_FILEPATH}cleanup_dry.txt",
    log:
        "logs/cleanup_dry.log",
    conda:
        "../envs/base_python.yaml"
    script:
        "../scripts/clean_dry.py"


rule clean:
    input:
        ancient(f"{DEFAULT_DEST_FILEPATH}cleanup_dry.txt"),
    log:
        "logs/clean.log",
    conda:
        "../envs/base_python.yaml"
    shell:
        "echo Removing temporary files from {input} > {log} && "
        "cat {input} | xargs rm && "
        "echo The following files were successfully deleted >> {log} && "
        "cat {input} >> {log} "
