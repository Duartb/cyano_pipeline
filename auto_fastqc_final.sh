mkdir -p fastqcOut/finalReads

for f in ./readsFiltered/*.fq;
do
 fastqc $f --outdir=./fastqcOut/finalReads/
done
