# Snakemake workflow: `Snakemake Pipeline for Illumina Raw Data`

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/currocam/IlluminaSnakemake/workflows/Tests/badge.svg?branch=main)](https://github.com/currocam/IlluminaSnakemake/actions?query=branch%3Amain+workflow%3ATests)

A Snakemake workflow for raw illumine reads to draft assemblies and annotations

## Setting up Snakemake

### Cloning repository

```bash
git clone https://github.com/currocam/IlluminaSnakemake
cd IlluminaSnakemake
```

### Activating Conda environment

```bash
conda activate sm_wgs
```

### Fixing BUSCO requirement for parallelization

```bash
export NUMEXPR_MAX_THREADS=100
```

## Usage

First of all, let's inspect the directory structure **before** you run snakemake, just after you clone this repository:

```bash
$ tree -L 2
.
├── LICENSE
├── README.md # You're reading this file rigth now
├── config
│   ├── README.md # How to configurate the pipeline
│   └── config.yaml # Where you're going to configurate the pipeline
├── enviroment.yaml # List of dependencies
└── workflow # Where the actual code is written
    ├── Snakefile
    └── envs
```

The script expects a directory named `reads` where the raw Illumina `fastq.gz` files should be moved into. Please check `config/README.md` for changing this default behavior. Files should be named as follows:

```bash
$ ls reads
PHK1-MST102_S132_L001_R1_001.fastq.gz  PHK1-MST103_S131_L001_R1_001.fastq.gz
PHK1-MST102_S132_L001_R2_001.fastq.gz  PHK1-MST103_S131_L001_R2_001.fastq.gz
```

### Running snakemake

Snakemake has a large `-help` documentation, which can be accessed as follows:

```bash
snakemake --help
```

Here, we'll see only the ones I have found more interesting. First of all, you may run a `dry-run` (to display what would be done)

```bash
snakemake -n --quiet
```

Or a more detailed one, including files and the shell commands that will be executed (nice for debugging):

```bash
snakemake -n -p
```

In order to actually run the pipeline, you must indicate the number of maximum cores you want to dedicate to the pipeline:

```bash
snakemake -c 100
```

First of all, let's inspect the directory structure **after** you run snakemake. You may be aware that new directories have been created (in addition to `reads`, where we moved the raw data files previously).

```bash
tree -L 2
.
├── LICENSE
├── README.md
├── config
├── enviroment.yaml
├── logs # Log files inside are been updating with the stdout and stderr, in case you want to check how is everything going.
│   ├── busco
│   ├── fastqc
│   ├── prokka
│   ├── quast
│   ├── renaming
│   ├── spades
│   └── trim_galore
├── reads
├── results
│   ├── allfastqc
│   ├── busco
│   ├── prokka
│   ├── quast
│   ├── renamed_raw_reads
│   ├── spades
│   └── trimmed
└── workflow
    ├── Snakefile
    └── envs
```

## Custom installation

### Creating an environment from a YAML file

First, make sure to activate the Conda base environment with

```bash
conda activate base
```

The `environment.yaml` file can be used to install all required software into an isolated Conda environment with the name `sm_wgs` via:

```bash
mamba env create --name sm_wgs --file environment.yaml
```

O, using Conda:

```bash
conda env create --name sm_wgs --file environment.yaml
```

Make sure a proper Docker installation is available on your machine.
