#!/usr/bin/env bash
set -e
mkdir -p $2/readsTrimmed

#Setting for progress bar
res=$(find $1/*.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning CutAdapt trimming on $res raw reads files:\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source /root/miniconda3/etc/profile.d/conda.sh
conda activate cutadapt_env

for f in $1/*.fastq;
do
  # Naming outputs
  base_name=${f##*/}; base_name=${base_name%.*};
  out="${base_name}_trimmed.fastq"

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -n "]  ($i/$res)  $(basename $f)" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [CUTADAPT_TRIMMING] cutadapt -u $3 -u $4 $f -o $2/readsTrimmed/$out : done" >> $2/commands.log

  # Running FastQC
  cutadapt -u $3 -u $4 $f -o $2/readsTrimmed/$out >>$2/console.log 2>> $2/console.log;
done

conda deactivate
