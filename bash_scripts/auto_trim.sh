#!/usr/bin/env bash
set -e
mkdir -p ./outputs/readsTrimmed

#Setting for progress bar
res=$(find ./rawReads/*.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning CutAdapt trimming on $res raw reads files:\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source activate cutadapt_env

for f in ./rawReads/*.fastq;
do
  # Naming outputs
  out="${f:11:-6}_trimmed.fastq"

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
  echo -e "$(date) [CUTADAPT_TRIMMING] cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out : done" >> ./outputs/commands.log

  # Running FastQC
  cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out >>./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
