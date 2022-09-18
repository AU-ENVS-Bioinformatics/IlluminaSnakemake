import os
import re
from pathlib import Path
def get_files_to_compare():
    if os.path.isfile(SAMPLES_TO_COMPARE_FILEPATH):
        with open(SAMPLES_TO_COMPARE_FILEPATH) as f:
            return f.read().splitlines()
    else:
        try:
            root_dir = f"{DEFAULT_DEST_FILEPATH}{SPADES_FILEPATH}"
            samples = [re.sub("_spades$", "", file) for file in os.listdir(root_dir) if "spades" in file]
            genomes = [f"{root_dir}{sample}_spades/{sample}.fasta" for sample in samples]
            return [genome for genome in genomes if os.path.isfile(genome)]
        except:
            return ""

def get_final_outdir_to_compare(SAMPLES_TO_COMPARE_FILEPATH):
    if SAMPLES_TO_COMPARE_FILEPATH == "":
        return "all"
    else: 
        return Path(SAMPLES_TO_COMPARE_FILEPATH).stem