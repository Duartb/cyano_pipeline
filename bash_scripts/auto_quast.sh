#!/usr/bin/env bash
set -e
mkdir -p ./outputs/quastOut

source activate quast_env

for file in ./refGenome/*.fasta
do
 ref=$file
done

#Setting for progress bar
res=$(find ./outputs/spadesOut/*/contigs.fasta -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Quast on $res cianobacterial binned contigs files ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

for f in ./outputs/finalGenomes/*.fasta
do
  # Naming inputs/ outputs
  base_name="${f:23:-6}"

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [QUAST] python /home/dbalata/miniconda3/envs/quast_env/bin/quast -r $ref -t $1 -o ./outputs/quastOut/$base_name $f  : done" >> ./outputs/commands.log

  # Running Quast
  python /home/dbalata/miniconda3/envs/quast_env/bin/quast -r $ref -t $1 -o ./outputs/quastOut/$base_name $f >> ./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
