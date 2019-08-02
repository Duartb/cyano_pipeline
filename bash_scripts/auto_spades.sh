#!/usr/bin/env bash

mkdir -p ./outputs/spadesOut

source activate spades_env

for f in ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do
 f1="${f::-30}_R1_001_trimmed_filtered.fastq";
 f2="${f::-30}_R2_001_trimmed_filtered.fastq";
 out="${f:24:-30}"
 echo -e "Running: spades.py -k 21,33,55,77 --careful -1 $f1 -2 $f2 -o ./outputs/spadesOut/$out -t $1"
 spades.py -k 21,33,55,77 --careful -1 $f1 -2 $f2 -o ./outputs/spadesOut/$out -t $1;
done

conda deactivate
