#!/usr/bin/env bash
set -e
mkdir -p ./outputs/coverages

#Setting for progress bar
res=$(find ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBMap on $res assembled cianobacterial contigs files to check coverage ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

for f in ./outputs/assemblies/*.fasta;
do
  # Naming inputs/ output
  base_name="${f:21:-10}";
  r1="${f:21:-10}_R1_001_trimmed_filtered.fastq"
  r2="${f:21:-10}_R2_001_trimmed_filtered.fastq"
  cov="${f:21:-6}_cov.txt"

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
 echo "$(date) [BBMAP_COVERAGE] bbmap.sh in1=./outputs/readsFiltered/$r1 in2=./outputs/readsFiltered/$r2 ref=$f covstats=./outputs/coverages/$cov path=./outputs/coverages t=$1 : done" >> ./outputs/commands.log

 # Running Quast
 bbmap.sh in1=./outputs/readsFiltered/$r1 in2=./outputs/readsFiltered/$r2 ref=$f covstats=./outputs/coverages/$cov path=./outputs/coverages t=$1 >>./outputs/console.log 2>> ./outputs/console.log;
done
