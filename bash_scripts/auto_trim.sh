#!/usr/bin/env bash

# Utilizar numa pasta que contenha os pair files (_001 e _002) das raw reads e o respetivo genomas de referencia com a terminaçao "_reference.fasta".

mkdir -p ./outputs/readsTrimmed

source /home/dbalata/miniconda3/bin/activate cutadapt_env

for f in ./rawReads/*.fastq;
do
 out="${f:11:-6}_trimmed.fastq"
 echo -e "Running: cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out"
 cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out;
done

conda deactivate
