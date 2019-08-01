#!/usr/bin/env bash

# Utilizar numa pasta que contenha os pair files (_001 e _002) das raw reads e o respetivo genomas de referencia com a terminaçao "_reference.fasta".

mkdir -p ./outputs/readsTrimmed

source /home/dbalata/miniconda3/bin/activate cutadapt_env

for f in ./rawReads/*.fq;
do
 out="${f:11:-3}_trimmed.fq"
 echo -e "Running:\ncutadapt -u 17 -u -5 $f -o ./outputs/readsTrimmed/$out"
 cutadapt -u 17 -u -5 $f -o ./outputs/readsTrimmed/$out;
done

conda deactivate
