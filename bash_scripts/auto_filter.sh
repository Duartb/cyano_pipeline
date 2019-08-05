#!/usr/bin/env bash
set -e
mkdir -p ./outputs/readsFiltered/temp

#Setting for progress bar
res=$(find ./outputs/readsTrimmed/*_R1_001_trimmed.fastq -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBDuk Quality filtering on $res pairs of raw reads files ($4 threads):\n\n"

for f in ./outputs/readsTrimmed/*_R1_001_trimmed.fastq;
do
  # Naming inputs/ outputs
  f1="${f:23:-21}_R1_001_trimmed.fastq";
  f2="${f:23:-21}_R2_001_trimmed.fastq";
  base_name="${f:23:-21}"

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++))
  progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [BBDUK_FILTERING_QUALITY] bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/temp/$f1 out2=./outputs/readsFiltered/temp/$f2 trimq=$1 t=$4 : done" >> ./outputs/commands.log

  # Running BBDuk
  bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/temp/$f1 out2=./outputs/readsFiltered/temp/$f2 trimq=$1 t=$4 >>./outputs/console.log 2>> ./outputs/console.log;
done

i=1; percent=0; percent=$(($i * 100 / $res )); progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning BBDuk GC content filtering on $res pairs of raw reads files ($4 threads):\n\n"

for f in ./outputs/readsFiltered/temp/*_R1_001_trimmed.fastq;
do

  # Naming inputs/ outputs
  base_name="${f:29:-21}"
  f1="${f::-21}_R1_001_trimmed.fastq";
  f2="${f::-21}_R2_001_trimmed.fastq";
  output1="${f:29:-21}_R1_001_trimmed_filtered.fastq";
  output2="${f:29:-21}_R2_001_trimmed_filtered.fastq";
  noCyano1="noCyano_${f:29:-21}_R1_001_trimmed_filtered.fastq";
  noCyano2="noCyano_${f:29:-21}_R2_001_trimmed_filtered.fastq";

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do echo -n '#'; done
  for ((j=progress; j<50; j++)) ; do echo -n ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [BBDUK_FILTERING_GC] bbduk.sh in1=$f1 in2=$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 outm1=./outputs/readsFiltered/$noCyano1 outm2=./outputs/readsFiltered/$noCyano2 mingc=$2 maxgc=$3 t=$4 : done" >> ./outputs/commands.log

  # Running BBDuk
  bbduk.sh in1=$f1 in2=$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 outm1=./outputs/readsFiltered/$noCyano1 outm2=./outputs/readsFiltered/$noCyano2 mingc=$2 maxgc=$3 t=$4 >>./outputs/console.log 2>> ./outputs/console.log;
done

rm -r ./outputs/readsFiltered/temp
