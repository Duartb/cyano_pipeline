#!/usr/bin/env bash

# Utilizar numa pasta que contenha os subdiretórios dos genomas assemblados e o respetivo genomas de referencia com a terminaçao "_ref.fasta".

#mkdir bbmap_out

mkdir -p ./outputs/quastOut

source /home/dbalata/miniconda3/bin/activate quast_env

for file in ./refGenome/*.fasta
do
 ref=$file
done

for f in ./outputs/spadesOut/*/scaffolds.fasta;
do
 out="${f:20:-16}";
 echo -e "Running:\npython /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t 4 -o ./outputs/quastOut/$out $f"
 python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t 4 -o ./outputs/quastOut/$out $f;
done

conda deactivate
