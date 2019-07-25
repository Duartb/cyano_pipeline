for f in ./raw/*_R1_001.fastq;
do
  newName="${f::-13}_1.fq";
  cp $f $newName
done

for f2 in ./raw/*_R2_001.fastq;
do
  newName2="${f2::-13}_2.fq";
  cp $f2 $newName2
done
