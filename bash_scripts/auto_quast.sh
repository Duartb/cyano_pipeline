#!/usr/bin/env bash
set -e
mkdir -p $1/quastOut

source ~/miniconda3/etc/profile.d/conda.sh
conda activate quast_env

#Setting for progress bar
res=$(find $1/spadesOut/*/contigs.fasta -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Quast on $res cianobacterial binned contigs files ($2 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

for f in $1/finalGenomes/*.fasta
do
  # Naming inputs/ outputs
  base_name=${f##*/}; base_name=${base_name%.*};

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
  echo -e "$(date) [QUAST] python3 ~/miniconda3/envs/quast_env/bin/quast -r $ref -t $2 -o $1/quastOut/$base_name $f  : done" >> $1/commands.log

  # Running Quast
  python3 ~/miniconda3/envs/quast_env/bin/quast -t $2 -o $1/quastOut/$base_name $f >> $1/console.log 2>> $1/console.log;
done

conda deactivate
