#!/usr/bin/env bash
set -e
mkdir -p ./outputs/krakenOut

#Setting for progress bar
res=$(find ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Kraken2 on $res pairs of processed reads files ($1 threads):\n\n"

source activate kraken2_env

for f in ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do
  # Naming inputs/ outputs
  base_name="${f:24:-30}"
  f1="${f::-30}_R1_001_trimmed_filtered.fastq";
  f2="${f::-30}_R2_001_trimmed_filtered.fastq";
  outK="${f:24:-30}.kraken";
  outR="${f:24:-30}.report";

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [KRAKEN2] kraken2 --db ~/tools/kraken2/ --paired $f1 $f2 --report ./outputs/krakenOut/$outR --output ~/newData/outputs/krakenOut/$outK --threads $1 : done" >> ./outputs/commands.log

  # Writing run log
  kraken2 --db ~/tools/kraken2/ --paired $f1 $f2 --report ./outputs/krakenOut/$outR --output ~/newData/outputs/krakenOut/$outK --threads $1 >> ./outputs/console.log 2>> ./outputs/console.log;
done

conda deactivate
