mkdir -p fastqcOut/finalReads

source /home/dbalata/miniconda3/bin/activate fastqc_env

for f in ./readsFiltered/*.fq;
do
 fastqc $f --outdir=./fastqcOut/finalReads/
done

conda deactivate
