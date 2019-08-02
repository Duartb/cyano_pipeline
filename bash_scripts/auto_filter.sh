#!/usr/bin/env bash

set -e

mkdir -p ./outputs/readsFiltered/temp

for f in ./outputs/readsTrimmed/*_R1_001_trimmed.fastq;
do
  f1="${f:23:-21}_R1_001_trimmed.fastq";
  f2="${f:23:-21}_R2_001_trimmed.fastq";
  echo -e "Running: bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/temp/$f1 out2=./outputs/readsFiltered/temp/$f2 trimq=$1 t=$4"
  bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/temp/$f1 out2=./outputs/readsFiltered/temp/$f2 trimq=$1 t=$4;
done

for f in ./outputs/readsFiltered/temp/*_R1_001_trimmed.fastq;
do
 f1="${f::-21}_R1_001_trimmed.fastq";
 f2="${f::-21}_R2_001_trimmed.fastq";
 output1="${f:29:-21}_R1_001_trimmed_filtered.fastq";
 output2="${f:29:-21}_R2_001_trimmed_filtered.fastq";
 noCyano1="noCyano_${f:29:-21}_R1_001_trimmed_filtered.fastq";
 noCyano2="noCyano_${f:29:-21}_R2_001_trimmed_filtered.fastq";
 echo -e "Running: bbduk.sh in1=$f1 in2=$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 outm1=./outputs/readsFiltered/$noCyano1 outm2=./outputs/readsFiltered/$noCyano2 mingc=$2 maxgc=$3 t=$4"
 bbduk.sh in1=$f1 in2=$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 outm1=./outputs/readsFiltered/$noCyano1 outm2=./outputs/readsFiltered/$noCyano2 mingc=$2 maxgc=$3 t=$4;
done

rm -r ./outputs/readsFiltered/temp
