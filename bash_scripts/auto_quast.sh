#!/usr/bin/env bash
set -e
mkdir -p ./outputs/quastOut

#Setting for progress bar
res=$(find ./outputs/spadesOut/*/scaffolds.fasta -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Quast on $res assembled scaffolds files ($1 threads):\n\n"

source activate quast_env

for file in ./refGenome/*.fasta
do
 ref=$file
done

for f in ./outputs/spadesOut/*/scaffolds.fasta;
do
  # Naming inputs/ output
  out="${f:20:-16}";

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $out" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [QUAST] python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t $1 -o ./outputs/quastOut/$out $f  : done" >> ./outputs/commands.log

  # Running Quast
  python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t $1 -o ./outputs/quastOut/$out $f >> ./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
