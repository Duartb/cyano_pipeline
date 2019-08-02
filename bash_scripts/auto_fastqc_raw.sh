mkdir -p ./outputs/fastqcOut/rawReads

source /home/dbalata/miniconda3/bin/activate fastqc_env

for f in ./rawReads/*.fastq;
do
 fastqc $f --outdir=./outputs/fastqcOut/rawReads/
done

conda deactivate
