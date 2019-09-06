#!/usr/bin/env bash
set -e
mkdir -p ./outputs/binned/$basename

#Setting for progress bar
res=$(find ./outputs/readsFiltered/*_R1R2.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning MaxBin2 on $res interleaved fastq files to bin sequences ($1 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate maxbin2_env

for f in ./outputs/readsFiltered/*_R1R2.fastq;
do
  # Naming inputs/ output
  base_name="${f:24:-11}";

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
 echo "$(date) [MAXBIN2] run_MaxBin.pl -contig ./outputs/spadesOut/$base_name/contigs.fasta -reads $f -out ./outputs/binned/$base_name -thread $1 : done" >> ./outputs/commands.log

 # Running Quast
 run_MaxBin.pl -contig ./outputs/spadesOut/$base_name/contigs.fasta -reads $f -out ./outputs/binned/$base_name -thread $1 >>./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
