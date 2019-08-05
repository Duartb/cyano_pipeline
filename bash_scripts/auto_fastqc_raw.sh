#!/usr/bin/env bash
set -e
mkdir -p ./outputs/fastqcOut/rawReads

#Setting for progress bar
res=$(find ./rawReads/*.fastq -maxdepth 0 | wc -l); i=1; percent=0; percent=$(($i * 100 / $res )); progress=$(($i * 50 / $res ));
printf "\nRunning FastQC on $res raw reads files ($1 threads):\n\n"

source activate fastqc_env

for f in ./rawReads/*.fastq;
do

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $(basename $f .fastq)" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))
  #percent=$(($i * 100 / $res ))

  # Writing run log
  echo "$(date) [FASTQC_RAW] fastqc $f --outdir=./outputs/fastqcOut/rawReads/ -t $1 : done" >> ./outputs/commands.log

  # Running FastQC
  fastqc $f --outdir=./outputs/fastqcOut/rawReads/ -t $1 >>./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
