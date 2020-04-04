#!/usr/bin/env bash
set -e
mkdir -p $2/fastqcOut/rawReads

#Setting for progress bar
res=$(find $1/*.fastq -maxdepth 0 | wc -l); i=1; percent=0; percent=$(($i * 100 / $res )); progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning FastQC on $res raw reads files ($3 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source /root/miniconda3/etc/profile.d/conda.sh
conda activate fastqc_env

for f in $1/*.fastq;
do

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -ne "] ($i/$res) $(basename $f .fastq)" $'\r'
  ((i++));  progress=$(($i * 50 / $res ))

  # Writing run log
  echo "$(date) [FASTQC_RAW] fastqc $f --outdir=$2/fastqcOut/rawReads/ -t $3 : done" >> $2/commands.log

  # Running FastQC
  fastqc $f --outdir=$2/fastqcOut/rawReads/ -t $3 >>$2/console.log 2>> $2/console.log;
done

conda deactivate
