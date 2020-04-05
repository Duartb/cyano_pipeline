#!/usr/bin/env bash
set -e
mkdir -p $1/readsFiltered/

#Setting for progress bar
res=$(find $1/readsTrimmed/*_R1_001_trimmed.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBDuk Quality filtering on $res pairs of raw reads files ($3 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base_env

for f in $1/readsTrimmed/*_R1_001_trimmed.fastq;
do
  # Naming inputs/ outputs
  base_name=${f##*/}; base_name="${base_name::-21}";
  f1="${base_name}_R1_001_trimmed.fastq";
  f2="${base_name}_R2_001_trimmed.fastq";
  output1="${base_name}_R1_001_trimmed_filtered.fastq";
  output2="${base_name}_R2_001_trimmed_filtered.fastq"
  interleaved="${base_name}_R1R2.fastq"


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
  echo -e "$(date) [BBDUK_FILTERING_QUALITY] ~/bbduk.sh in1=$1/readsTrimmed/$f1 in2=$1/readsTrimmed/$f2 out1=$1/readsFiltered/$output1 out2=$1/readsFiltered/$output2 trimq=$2 t=$3 : done" >> $1/commands.log

  # Running BBDuk
  ~/bbmap/bbduk.sh in1=$1/readsTrimmed/$f1 in2=$1/readsTrimmed/$f2 out1=$1/readsFiltered/$output1 out2=$1/readsFiltered/$output2 trimq=$2 t=$3 >> $1/console.log 2>> $1/console.log

  # Running BBSuit reformat
  ~/bbmap/reformat.sh in1=$1/readsFiltered/$output1 in2=$1/readsFiltered/$output2 out=$1/readsFiltered/$interleaved overwrite=true >> $1/console.log 2>> $1/console.log;
done

conda deactivate
