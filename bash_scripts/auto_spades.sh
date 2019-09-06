#!/usr/bin/env bash
set -e
mkdir -p ./outputs/spadesOut

#Setting for progress bar
res=$(find ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning SPAdes on $res pairs of processed raw reads files ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate spades_env

for f in ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do

  # Naming inputs/ output
  f1="${f::-30}_R1_001_trimmed_filtered.fastq";
  f2="${f::-30}_R2_001_trimmed_filtered.fastq";
  out="${f:24:-30}"

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -n "]  ($i/$res)  $out" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  echo -e "$(date) [SPADES] spades.py -k 21,33,55,77 --careful -1 $f1 -2 $f2 -o ./outputs/spadesOut/$out -t $1 : done" >> ./outputs/commands.log

  spades.py -k 21,33,55,77 --careful -1 $f1 -2 $f2 -o ./outputs/spadesOut/$out -t $1 >>./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
