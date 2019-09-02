#!/usr/bin/env bash
set -e
mkdir -p ./outputs/krakenOut/raw

#Setting for progress bar
res=$(find ./rawReads/*_R1_001.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Kraken2 on $res pairs of raw reads files ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate kraken2_env

for f in ./rawReads/*_R1_001.fastq;
do
  # Naming inputs/ outputs
  base_name="${f:11:-13}"
  f1="${f::-13}_R1_001.fastq";
  f2="${f::-13}_R2_001.fastq";
  outK="${f:11:-13}.kraken";
  outR="${f:11:-13}.report";

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
  echo -e "$(date) [KRAKEN2] kraken2 --db ~/tools/kraken2/ --paired $f1 $f2 --report ./outputs/krakenOut/raw/$outR --output ~/newData/outputs/krakenOut/$outK --threads $1 : done" >> ./outputs/commands.log

  # Writing run log
  kraken2 --db ~/tools/kraken2/ --paired $f1 $f2 --report ./outputs/krakenOut/raw/$outR --output ~/newData/outputs/krakenOut/raw/$outK --threads $1 >> ./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
