#!/usr/bin/env bash
set -e
mkdir -p $1/binned/$basename

#Setting for progress bar
res=$(find $1/readsFiltered/*_R1R2.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning MaxBin2 on $res interleaved fastq files to bin sequences ($2 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate maxbin2_env

for f in $1/readsFiltered/*_R1R2.fastq;
do
  # Naming inputs/ output
  base_name=${f##*/}; base_name="${base_name::-11}";

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
 echo "$(date) [MAXBIN2] run_MaxBin.pl -contig $1/spadesOut/$base_name/contigs.fasta -reads $f -out $1/binned/$base_name -prob_threshold 0.95 -plotmarker -thread $2 : done" >> $1/commands.log

 # Running Quast
 run_MaxBin.pl -contig $1/spadesOut/$base_name/contigs.fasta -reads $f -out $1/binned/$base_name -prob_threshold 0.95 -plotmarker -thread $2 >>$1/console.log 2>> $1/console.log;
done

conda deactivate
