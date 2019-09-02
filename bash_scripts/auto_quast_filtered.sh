#!/usr/bin/env bash
set -e
mkdir -p ./outputs/quastOut

#Setting for progress bar
res=$(find ./outputs/spadesOut/*/contigs_filtered.fasta -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Quast on $res filtered assembled contigs files ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate quast_env

for file in ./refGenome/*
do
 ref=$file
done

for f in ./outputs/spadesOut/*/contigs_filtered.fasta;
do
  # Naming inputs/ output
  out="${f:20:-23}_filtered";

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -n "]  ($i/$res)  $out" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [QUAST] python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t $1 -o ./outputs/quastOut/$out $f  : done" >> ./outputs/commands.log

  # Running Quast
  python /home/dbalata/miniconda3/envs/quast_env/bin/quast  -r $ref -t $1 -o ./outputs/quastOut/$out $f >> ./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
