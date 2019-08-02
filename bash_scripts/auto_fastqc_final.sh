mkdir -p ./outputs/fastqcOut/finalReads

source activate fastqc_env

for f in ./outputs/readsFiltered/*.fastq;
do
 echo "Running: fastqc $f --outdir=./outputs/fastqcOut/finalReads/ -t $1"
 fastqc $f --outdir=./outputs/fastqcOut/finalReads/ -t $1
done

conda deactivate
