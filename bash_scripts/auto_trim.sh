#!/usr/bin/env bash
set -e
mkdir -p ./outputs/readsTrimmed

#Setting for progress bar
res=$(find ./rawReads/*.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning CutAdapt trimming on $res raw reads files:\n\n"

source activate cutadapt_env

for f in ./rawReads/*.fastq;
do

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $(basename $f)" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Naming outputs
  out="${f:11:-6}_trimmed.fastq"

  # Writing run log
  echo -e "$(date) [CUTADAPT_TRIMMING] cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out : done" >> ./outputs/commands.log

  # Running FastQC
  cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out >>./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
