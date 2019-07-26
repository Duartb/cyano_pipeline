#!/usr/bin/env bash

set -e

mkdir -p ./outputs/readsFiltered/temp

for f in ./outputs/readsTrimmed/*_1_trimmed.fq;
do
  f1="${f:23:-13}_1_trimmed.fq";
  f2="${f:23:-13}_2_trimmed.fq";
  echo -e "Running:\nbbduk.sh in1=./rawReads/$f1 in2=./rawReads/$f2 out1=./outputs/readsFiltered/temp/$f1 out2=./outputs/readsFiltered/temp/$f2 trimq=33"
  bbduk.sh in1=./outputs/readsTrimmed/$f1 in2=./outputs/readsTrimmed/$f2 out1=./outputs/readsFiltered/temp/$f1 out2=./outputs/readsFiltered/temp/$f2 trimq=33;
done

for f in ./outputs/readsFiltered/temp/*_1_trimmed.fq;
do
 f1="${f::-13}_1_trimmed.fq";
 f2="${f::-13}_2_trimmed.fq";
 output1="${f:29:-13}_trimmed_filtered_1.fq";
 output2="${f:29:-13}_trimmed_filtered_2.fq";
 noCyano1="noCyano_${f:29:-13}_trimmed_filtered_1.fq";
 noCyano2="noCyano_${f:29:-13}_trimmed_filtered_2.fq";
 echo -e "Running:\nbbduk.sh in1=$f1 in2=$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 outm1=./outputs/readsFiltered/$noCyano1 outm2=./outputs/readsFiltered/$noCyano2 mingc=0.23 maxgc=0.63 t=4;"
 bbduk.sh in1=$f1 in2=$f2 out1=./outputs/readsFiltered/$output1 out2=./outputs/readsFiltered/$output2 outm1=./outputs/readsFiltered/$noCyano1 outm2=./outputs/readsFiltered/$noCyano2 mingc=0.23 maxgc=0.63 t=4;
done

rm -r ./outputs/readsFiltered/temp
