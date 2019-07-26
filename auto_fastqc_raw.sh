mkdir -p fastqcOut/rawReads

source /home/dbalata/miniconda3/bin/activate fastqc_env

for f in ./rawReads/*.fq;
do
 fastqc $f --outdir=./fastqcOut/rawReads/
done

conda deactivate
