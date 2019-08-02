#!/usr/bin/env bash
set -e

mkdir -p ./outputs/readsTrimmed

source activate cutadapt_env

for f in ./rawReads/*.fastq;
do
 out="${f:11:-6}_trimmed.fastq"
 echo -e "$(date) [CUTADAPT_TRIMMING] cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out : done" | tee -a ./outputs/commands.log
 cutadapt -u $1 -u $2 $f -o ./outputs/readsTrimmed/$out 2>> ./outputs/console.log;
done

conda deactivate
