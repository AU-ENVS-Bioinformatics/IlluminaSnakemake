from pathlib import Path
import itertools
from typing import List
indirs = [Path(dir) for dir in snakemake.input]
outdir = Path(snakemake.output[0]).parent
log_file = Path(snakemake.log[0])

## Create output dir
outdir.mkdir(parents=True, exist_ok=True)

def find_gbk(dir: Path) -> List[Path]:
    return dir.glob('*.gbk')

infiles = list(itertools.chain(*list(find_gbk(dir) for dir in indirs)))
with log_file.open('w') as log:
    for file in infiles:
        with file.open() as old:
            print(f"Editing {str(file)}", file=log)
            new_organism_name = file.with_suffix('').name.split('_')[0]
            lines = old.readlines()
            lineOfInterest = lines[6] # change the line number here
            lines[6] =  lineOfInterest[0 : 12] + new_organism_name + '\n'
            new_file = (outdir / file.name)
            with new_file.open('w') as edited:
                edited.writelines(lines)
            print(f"Done!", file=log)