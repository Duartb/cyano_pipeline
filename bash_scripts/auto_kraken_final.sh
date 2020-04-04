#!/usr/bin/env bash
set -e
mkdir -p $1/krakenOut/final/reports
mkdir -p $1/krakenOut/final/outputs

#Setting for progress bar
res=$(find $1/binned/*.fasta -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning Kraken2 on $res pairs of processed reads files ($3 threads):\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

source /root/miniconda3/etc/profile.d/conda.sh
conda activate kraken2_env

if [ ! -d "/home/kraken_db/$2" ]; then
  if [[ "$2" == "kraken_standard" ]]; then
    kraken2-build --standard --db /home/kraken_db/$2
  elif [[ "$2" == "kraken_silva_16s" ]]; then
    kraken2-build --special_silva --db /home/kraken_db/$2
  fi
fi

for f in $1/binned/*.fasta;
do
  # Naming inputs/ outputs
  base_name=${f##*/}; base_name="${base_name%.*}";

  # Drawing progress Bar
  echo -n "["
  for ((j=0; j<progress; j++)) ; do
  if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  else echo -ne "${Green}#${NoColor}"; fi; done
  for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  echo -n "]  ($i/$res)  $base_name" $'\r'
  ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo -e "$(date) [KRAKEN2] kraken2 --db /home/kraken_db/$2 $f --report $1/krakenOut/final/$f  --threads $3 : done" >> $1/commands.log

  # Writing run log
  kraken2 --db /home/kraken_db/$2 $f --report $1/krakenOut/final/reports/$base_name.report --output $1/krakenOut/final/outputs/$base_name.output --threads $3 >> $1/console.log 2>> $1/console.log;
done

conda deactivate
