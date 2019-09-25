#!/usr/bin/env bash
set -e
mkdir -p ./outputs/readsFiltered/

#Setting for progress bar
res=$(find ./outputs/readsTrimmed/*_R1_001_trimmed.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBDuk Quality filtering on $res pairs of raw reads files ($2 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

for f in ./outputs/readsTrimmed/*_R1_001_trimmed.fastq;
do
  # Naming inputs/ outputs
  f1="${f:23:-21}_R1_001_trimmed.fastq";
  f2="${f:23:-21}_R2_001_trimmed.fastq";
  output1="${f:23:-21}_R1_001_trimmed_filtered.fastq";
  output2="${f:23:-21}_R2_001_trimmed_filtered.fastq"
  interleaved="${f:23:-21}_R1R2.fastq"
  base_name="${f:23:-21}"

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++))
  progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [BBDUK_FILTERING_QUALITY] bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 trimq=$1 t=$2 : done" >> ./outputs/commands.log

  # Running BBDuk
  bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 trimq=$1 t=$4 >> ./outputs/console.log 2>> ./outputs/console.log

  # Running BBSuit reformat
  reformat.sh in1=./outputs/readsFiltered/$output1 in2=./outputs/readsFiltered/$output2 out=./outputs/readsFiltered/$interleaved overwrite=true >> ./outputs/console.log 2>> ./outputs/console.log;
done
