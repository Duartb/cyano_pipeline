#!/usr/bin/env bash
set -e
mkdir -p ./outputs/coverages

#Setting for progress bar
res=$(find ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBMap on $res assembled scaffolds files to check coverage ($1 threads):\n\n"

for f in ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do
  # Naming inputs/ output
  base_name="${f:24:-30}";
  r1="${f::-30}_R1_001_trimmed_filtered.fastq"
  r2="${f::-30}_R2_001_trimmed_filtered.fastq"
  cov="${f:24:-30}_cov.txt"

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
 echo "$(date) [BBMAP_COVERAGE] bbmap.sh in1=$r1 in2=$r2 ref=./outputs/spadesOut/$base_name/scaffolds.fasta covstats=./outputs/coverages/$cov path=./outputs/coverages t=$1 : done" >> ./outputs/commands.log

 # Running Quast
 bbmap.sh in1=$r1 in2=$r2 ref=./outputs/spadesOut/$base_name/scaffolds.fasta covstats=./outputs/coverages/$cov path=./outputs/coverages t=$1 >>./outputs/console.log 2>> ./outputs/console.log;
done
