import os
import shutil
for original, target in zip(snakemake.input, snakemake.output):
    os.makedirs(os.path.dirname(target), exist_ok=True)
    shutil.copyfile(original, target)