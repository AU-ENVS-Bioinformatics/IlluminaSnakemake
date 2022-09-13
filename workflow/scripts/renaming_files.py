import os
import shutil
import re

regular_expression = ".+-(.+)_.+_.+_(.+)_.+\.fastq.gz"
input_dir = snakemake.params[0]
output_dir = snakemake.params[1]

def copy_file(original: str, target: str) -> None:
    os.makedirs(os.path.dirname(target), exist_ok=True)
    shutil.copyfile(original, target)

for file in os.listdir(input_dir):
    match = re.match(regular_expression, file)
    if match:
        original = input_dir + match.string
        print(original)
        target = output_dir + match.group(1) + "_" + match.group(2) + ".fastq.gz"
        print(target)
        if os.path.exists(target):
            print('The previous file was already there.')
        else:
            copy_file (original, target)
  