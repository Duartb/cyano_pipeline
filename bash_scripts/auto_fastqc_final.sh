#!/usr/bin/env bash
set -e
mkdir -p $1/fastqcOut/finalReads

#Setting for progress bar
res=$(find $1/readsFiltered/*trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning FastQC on $res processed reads files ($2 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastqc_env

for f in $1/readsFiltered/*_trimmed_filtered.fastq;
do
  # Naming inputs/ outputs
  base_name=${f##*/}; base_name="${base_name::-23}";

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
  echo "$(date) [FASTQC_FINAL] fastqc $f --outdir=$1/fastqcOut/finalReads/ -t $2 : done" >> $1/commands.log

  # Running FastQC
  fastqc $f --outdir=$1/fastqcOut/finalReads/ -t $2 >>$1/console.log 2>> $1/console.log;
done

conda deactivate
