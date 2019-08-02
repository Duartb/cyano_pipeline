mkdir -p ./outputs/coverages

for f in ./outputs/readsFiltered/*_R1_001_trimmed_filtered.fastq;
do
 sample="${f:24:-30}";
 r1="${f::-30}_R1_001_trimmed_filtered.fastq"
 r2="${f::-30}_R2_001_trimmed_filtered.fastq"
 cov="${f:24:-30}_cov.txt"

 echo "Running: bbmap.sh in1=$r1 in2=$r2 ref=./outputs/spadesOut/$sample/scaffolds.fasta covstats=./outputs/coverages/$cov path=./outputs/coverages t=$1"
 bbmap.sh in1=$r1 in2=$r2 ref=./outputs/spadesOut/$sample/scaffolds.fasta covstats=./outputs/coverages/$cov path=./outputs/coverages t=$1;

done
