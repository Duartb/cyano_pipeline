#!/usr/bin/env bash

set -e

mkdir -p readsFiltered/temp

for f in ./readsTrimmed/*_1_trimmed.fq;
do
  f1="${f:15:-13}_1_trimmed.fq";
  f2="${f:15:-13}_2_trimmed.fq";
  echo -e "Running:\nbbduk.sh in1=./rawReads/$f1 in2=./rawReads/$f2 out1=./readsFiltered/temp/$f1 out2=./readsFiltered/temp/$f2 trimq=33"
  bbduk.sh in1=./readsTrimmed/$f1 in2=./readsTrimmed/$f2 out1=./readsFiltered/temp/$f1 out2=./readsFiltered/temp/$f2 trimq=33;
done

for f in ./readsFiltered/temp/*_1_trimmed.fq;
do
 f1="${f::-13}_1_trimmed.fq";
 f2="${f::-13}_2_trimmed.fq";
 output1="${f:21:-13}_trimmed_filtered_1.fq";
 output2="${f:21:-13}_trimmed_filtered_2.fq";
 noCyano1="noCyano_${f:21:-13}_trimmed_filtered_1.fq";
 noCyano2="noCyano_${f:21:-13}_trimmed_filtered_2.fq";
 echo -e "Running:\nbbduk.sh in1=$f1 in2=$f2 out1=./readsFiltered/$output1 out2=./readsFiltered/$output2 outm1=./readsFiltered/$noCyano1 outm2=./readsFiltered/$noCyano2 mingc=0.23 maxgc=0.63 t=4;"
 bbduk.sh in1=$f1 in2=$f2 out1=./readsFiltered/$output1 out2=./readsFiltered/$output2 outm1=./readsFiltered/$noCyano1 outm2=./readsFiltered/$noCyano2 mingc=0.23 maxgc=0.63 t=4;
done

rm -r readsFiltered/temp
