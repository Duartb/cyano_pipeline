#!/usr/bin/env bash

mkdir -p ./outputs/krakenOut

source activate kraken2_env

for f in ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do
 f1="${f::-30}_R1_001_trimmed_filtered.fastq";
 f2="${f::-30}_R2_001_trimmed_filtered.fastq";
 outK="${f:24:-30}.kraken";
 outR="${f:24:-30}.report";
 echo -e "Running: kraken2 --db ~/tools/kraken2/ --paired $f1 $f2 --report ./outputs/krakenOut/$outR --output ~/newData/outputs/krakenOut/$outK --threads $1"
 kraken2 --db ~/tools/kraken2/ --paired $f1 $f2 --report ./outputs/krakenOut/$outR --output ~/newData/outputs/krakenOut/$outK --threads $1;
done

conda deactivate
