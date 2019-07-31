#!/usr/bin/env bash

mkdir -p ./outputs/spadesOut

source /home/dbalata/miniconda3/bin/activate spades_env

for f in ./outputs/readsFiltered/*_1.fq;
do
 f1="${f::-5}_1.fq";
 f2="${f::-5}_2.fq";
 out="${f:24:-5}"
 echo -e "Running:\nspades.py -k 21,33,55,77 --careful -1 $f1 -2 $f2 -o ./outputs/spadesOut/$out -t 4"
 spades.py -k 21,33,55,77 --careful -1 $f1 -2 $f2 -o ./outputs/spadesOut/$out -t 4;
done

conda deactivate
