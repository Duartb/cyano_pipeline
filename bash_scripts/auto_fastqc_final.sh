#!/usr/bin/env bash
set -e
mkdir -p ./outputs/fastqcOut/finalReads

#Setting for progress bar
res=$(find ./outputs/readsFiltered/*trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning FastQC on $res processed reads files ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate fastqc_env

for f in ./outputs/readsFiltered/*_trimmed_filtered.fastq;
do
  # Naming inputs/ outputs
  base_name="${f:24:-23}"

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
  echo "$(date) [FASTQC_FINAL] fastqc $f --outdir=./outputs/fastqcOut/finalReads/ -t $1 : done" >> ./outputs/commands.log

  # Running FastQC
  fastqc $f --outdir=./outputs/fastqcOut/finalReads/ -t $1 >>./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
