# Snakemake workflow: `Snakemake Pipeline for Illumina Raw Data`

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/currocam/IlluminaSnakemake/workflows/Tests/badge.svg?branch=main)](https://github.com/currocam/IlluminaSnakemake/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow for `A Snakemake workflow for raw illumine reads to draft assemblies and annotations`


## Usage

### Creating an environment from an environment.yaml file

First, make sure to activate the conda base environment with
``` bash
conda activate base
```

The environment.yaml file can be used to install all required software into an isolated Conda environment with the name sm_wgs via
``` bash
mamba env create --name sm_wgs --file environment.yaml
```
O, using conda: 
``` bash
conda env create --name sm_wgs --file environment.yaml
```

To activate this environment, use
``` bash
conda activate sm_wgs
```

To deactivate an active environment, use

``` bash
conda deactivate
```

TODO!