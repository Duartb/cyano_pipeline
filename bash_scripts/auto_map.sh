#!/usr/bin/env bash
set -e
mkdir -p $1/mappedReads

#Setting for progress bar
res=$(find $1/readsFiltered/*_R1_001_trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBMap on $res assembled cianobacterial contigs files to check coverage ($2 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source /root/miniconda3/etc/profile.d/conda.sh
conda activate base_env

for f in $1/spadesOut/*/contigs.fasta;
do
  # Naming inputs/ output
  base_name=${f##*spadesOut/}; echo $base_name
  base_name="${base_name::-14}";
  r1="${base_name}_R1_001_trimmed_filtered.fastq";
  r2="${base_name}_R2_001_trimmed_filtered.fastq";
  cov="${base_name}_cov.txt";

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
 echo "$(date) [BBMAP_COVERAGE] /home/qtuser/bbmap/bbmap.sh in1=$1/readsFiltered/$r1 in2=$1/readsFiltered/$r2 ref=$f covstats=$1/coverages/$cov slow k=12 path=$1/coverages t=$2 : done" >> $1/commands.log

 # Running BBMap
 /home/qtuser/bbmap/bbmap.sh in1=$1/readsFiltered/$r1 in2=$1/readsFiltered/$r2 ref=$f outm=$1/mappedReads/$base_name covstats=$1/coverages/$cov slow k=12 path=$1/coverages t=$2 >>$1/console.log 2>> $1/console.log;
done

conda deactivate
