## Customizing the input and output directories

You can change the name of the following directories by editing the `config/config.yaml` file. Please, don't remove any of these.

```YAML
DEFAULT_SOURCE_FILEPATH : "reads/"
DEFAULT_DEST_FILEPATH : "results/"
RENAMED_READS_FILEPATH : "renamed_raw_reads/"
TRIMMED_READS_FILEPATH : "trimmed/"
FASTQC_FILEPATH : "allfastqc/"
SPADES_FILEPATH : "spades/"
QUAST_FILEPATH : "quast/"
PROKKA_FILEPATH : "prokka/"
```

## Customizing the pipeline

For further configuration of the pipeline, please use the following scheme: **the name of the program followed by the list of program flags (as they would normally be used)**.

Although not necessary, it would be ideal to:

- Create a custom configuration file for each use case
- Enclose the text in quotation marks
- Separate the different commands on different lines
- Add comments.

That is, although this would be perfectly valid:

```YAML
trim_galore:
  - --trim-n --length 60 --illumina
fastqc:
    - "--quiet"
```

This is preferable:

```YAML
trim_galore:
  - "--length 60" #Discard reads that became shorter than INT because of either quality or adapter trimming
  - "--trim-n" #Removes Ns from either side of the read.
  - "--illumina" #Illumina adapter

fastqc:
  - "--quiet" #Supress all progress messages on stdout and only report errors.
```

## A few considerations for reproducibility

That is very opinionated but:

- If you found yourself editing the configuration file for a new case of use (maybe eucaryotes instead of prokaryotes), consider creating a different configuration file to avoid unexpected behavior. You can specify which configuration file to use using the `--configfile` flag.

```bash
cp config/config.yaml config/config_other_case.yaml
vi config/config_other_case.yaml
snakemake -c50 --configfile config/config_other_case.yaml
```

- If you want to modify the default behavior of the pipeline, consider committing the changes. This way, it would be easier to reproduce previous analyses. This directory is a git repository, then you can just do:

```bash
git add config/config.yaml
git commit -m "Editing configuration file because ..."
```
