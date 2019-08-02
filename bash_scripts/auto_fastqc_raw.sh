#!/usr/bin/env bash
set -e

mkdir -p ./outputs/fastqcOut/rawReads

source activate fastqc_env

for f in ./rawReads/*.fastq;
do
  echo "$(date) [FASTQC_RAW] fastqc $f --outdir=./outputs/fastqcOut/rawReads/ -t $1 : done" | tee -a ./outputs/commands.log
  fastqc $f --outdir=./outputs/fastqcOut/rawReads/ -t $1 2>> ./outputs/console.log;
done

conda deactivate
