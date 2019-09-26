#!/usr/bin/env bash
set -e
mkdir -p $1/krakenOut/raw/reports
mkdir -p $1/krakenOut/raw/outputs

#Setting for progress bar
res=$(find $1/readsFiltered/*_R1_001_trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Kraken2 on $res pairs of raw reads files ($3 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate kraken2_env

for f in $1/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do
  # Naming inputs/ outputs
  base_name=${f##*/}; base_name="${base_name::-30}"
  f1="${f::-30}_R1_001_trimmed_filtered.fastq";
  f2="${f::-30}_R2_001_trimmed_filtered.fastq";
  outK="${base_name}.kraken";
  outR="${base_name}.report";

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
  echo -e "$(date) [KRAKEN2] kraken2 --db ~/tools/$2 --paired $f1 $f2 --report $1/krakenOut/raw/reports/$outR --output $1/krakenOut/raw/outputs/$outK --threads $3 : done" >> $1/commands.log

  # Writing run log
  kraken2 --db ~/tools/$2 --paired $f1 $f2 --report $1/krakenOut/raw/reports/$outR --output $1/krakenOut/raw/outputs/$outK --threads $3 >> $1/console.log 2>> $1/console.log;
done

conda deactivate
