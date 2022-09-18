RENAMED_READS_FILEPATH = config.get("RENAMED_READS_FILEPATH", "renamed_raw_reads/")
TRIMMED_READS_FILEPATH = config.get("TRIMMED_READS_FILEPATH", "trimmed/")
trim_galore_params = config.get("trim_galore", "")
trim_galore_threads = min(AVAILABLE_THREADS, 8)
trim_galore_params.append(f'--cores {trim_galore_threads}')

rule trim_galore:
    input:
        [
            f"{DEFAULT_DEST_FILEPATH}{RENAMED_READS_FILEPATH}{{sample}}_R1.fastq.gz",
            f"{DEFAULT_DEST_FILEPATH}{RENAMED_READS_FILEPATH}{{sample}}_R2.fastq.gz",
        ],
    output:
        f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R1_val_1.fq.gz",
        f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R1.fastq.gz_trimming_report.txt",
        f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R2_val_2.fq.gz",
        f"{DEFAULT_DEST_FILEPATH}{TRIMMED_READS_FILEPATH}{{sample}}_R2.fastq.gz_trimming_report.txt",
    params:
        extra=" ".join(trim_galore_params),        
    log:
        "logs/trim_galore/{sample}.log",
    wrapper:
        "v1.12.1/bio/trim_galore/pe"