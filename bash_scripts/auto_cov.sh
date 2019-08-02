
mkdir -p ./outputs/coverages

for f in ./outputs/readsFiltered/*_R1_001.fastq;
do
 sample="${f:24:-13}";
 r1="${f::-13}_R1_001.fastq"
 r2="${f::-13}_R2_001.fastq"
 cov="${f:24:-13}_cov.txt"

 echo "Running:\nin1=$r1 in2=$r2 ref=./outputs/spadesOut/$sample/contigs.fasta covstats=./outputs/coverages/$cov"
 bbduk.sh in1=$r1 in2=$r2 ref=./outputs/spadesOut/$sample/contigs.fasta covstats=./outputs/coverages/$cov;

done
