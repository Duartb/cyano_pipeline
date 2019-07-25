#!/usr/bin/env bash

set -e

mkdir readsFiltered/temp

for f in ./readsTrimmed/*_1.fq;
do
  f1="${f:11:-5}_filtered_1.fq";
  f2="${f:11:-5}_filtered_2.fq";
  echo -e "Running:\nbbduk.sh in1=./rawReads/$f1 in2=./rawReads/$f2 out1=./readsFiltered/temp/$f1 out2=./readsFiltered/temp/$f2 trimq=33"
  bbduk.sh in1=./rawReads/$f1 in2=./rawReads/$f2 out1=./readsFiltered/temp/$f1 out2=./readsFiltered/temp/$f2 trimq=33;
done

for f in ./readsFiltered/temp/*_1.fq;
do
 f1="${f::-5}_1.fq";
 f2="${f::-5}_2.fq";
 output1="${f:21:-5}_1.fq";
 output2="${f:21:-5}_2.fq";
 noCyano1="noCyano_${f:21:-5}_1.fq";
 noCyano2="noCyano_${f:21:-5}_2.fq";
 echo -e "Running:\nbbduk.sh in1=$f1 in2=$f2 out1=./reasdFiltered/$output1 out2=./reasdFiltered/$output2 outm1=./reasdFiltered/$noCyano1 outm2=./reasdFiltered/$noCyano2 mingc=0.23 maxgc=0.63 t=4;"
 bbduk.sh in1=$f1 in2=$f2 out1=./reasdFiltered/$output1 out2=./reasdFiltered/$output2 outm1=./reasdFiltered/$noCyano1 outm2=./reasdFiltered/$noCyano2 mingc=0.23 maxgc=0.63 t=4;
done

rm -r readsFiltered/temp
