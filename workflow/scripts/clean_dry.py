from pathlib import Path
from re import search

DEFAULT_DEST_FILEPATH =snakemake.config.get("DEFAULT_DEST_FILEPATH", "results/")

def find_temporary_files(root: Path, exclude: list[str]):
    for item in root.iterdir():
        is_excluded = any(search(pattern, str(item)) for pattern in exclude)
        if is_excluded:
            continue
        if item.is_dir():
            yield from find_temporary_files(item, exclude)
            continue
        yield item

EXCLUDE_LIST = [
    "cleanup_dry.txt",
    "log",
    ".snakemake_timestamp",
    snakemake.config.get("FASTQC_FILEPATH", "allfastqc/"),
    snakemake.config.get("RENAMED_READS_FILEPATH", "renamed_raw_reads/"),
    snakemake.config.get("BARRNAP_FILEPATH", "barrnap/"),
    snakemake.config.get("QUAST_FILEPATH", "quast/"),
    snakemake.config.get("SPADES_FILEPATH", "spades/"),
    snakemake.config.get("PROKKA_FILEPATH", "prokka/"),
    snakemake.config.get("TRIMMED_READS_FILEPATH", "trimmed/"),
    "short_summary", # results/busco/CA11s2/short_summary.specific.bacteria_odb10.CA11s2.json
    "lineage.ms", # results/checkM/all/lineage.ms
    "figures", #results/dRep/all/figures
    "data_tables", # results/dRep/all/data_tables
    "report.txt",
    "spades",
]
temporary_files = find_temporary_files(Path(DEFAULT_DEST_FILEPATH), EXCLUDE_LIST)
outfile = snakemake.output[0]
with open(outfile, 'w') as file:
    for temp in temporary_files:
        file.write(f"{str(temp)}\n")