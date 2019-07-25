mkdir -p fastqcOut/rawReads

for f in ./raw/*.fq;
do
 fastqc $f --outdir=./fastqcOut/rawReads/
done
