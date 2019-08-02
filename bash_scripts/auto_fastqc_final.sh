#!/usr/bin/env bash
set -e

mkdir -p ./outputs/fastqcOut/finalReads

source activate fastqc_env

for f in ./outputs/readsFiltered/*.fastq;
do
 echo "$(date) [FASTQC_FINAL] fastqc $f --outdir=./outputs/fastqcOut/finalReads/ -t $1 : done" | tee -a ./outputs/commands.log
 fastqc $f --outdir=./outputs/fastqcOut/finalReads/ -t $1 2>> ./outputs/console.log;
done

conda deactivate
