#!/usr/bin/env bash
set -e

mkdir -p ./outputs/quastOut

source activate quast_env

for file in ./refGenome/*.fasta
do
 ref=$file
done

for f in ./outputs/spadesOut/*/scaffolds.fasta;
do
 out="${f:20:-16}";
 echo -e "$(date) [QUAST] python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t $1 -o ./outputs/quastOut/$out $f  : done" | tee -a ./outputs/commands.log
 python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t $1 -o ./outputs/quastOut/$out $f 2>> ./outputs/console.log;
done

conda deactivate
