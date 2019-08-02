mkdir -p ./outputs/fastqcOut/rawReads

source /home/dbalata/miniconda3/bin/activate fastqc_env

for f in ./rawReads/*.fastq;
do
  echo "Running: fastqc $f --outdir=./outputs/fastqcOut/rawReads/ -t $1"
  fastqc $f --outdir=./outputs/fastqcOut/rawReads/ -t $1
done

conda deactivate
