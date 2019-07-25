#!/usr/bin/env bash

# Utilizar numa pasta que contenha os pair files (_001 e _002) das raw reads e o respetivo genomas de referencia com a terminaçao "_reference.fasta".

mkdir readsTrimmed

for f in ./raw/*.fq;
do
 out="trimmed_${f:6:-3}.fq"
 echo -e "Running:\ncutadapt -u 17 -u -5 ./$f -o ./readsTrimmed/$out"
 cutadapt -u 17 -u -5 ./$f -o ./readsTrimmed/$out;
done
