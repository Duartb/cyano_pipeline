set -e
mkdir -p ./outputs/quastOut

#Setting for progress bar
res=$(find ./outputs/spadesOut/*/contigs.fasta -maxdepth 0 | wc -l); i=1; progress=$(($i * 50 / $res ));
echo ""; printf "\nRunning custom filtering script on $res assembled contigs files:\n\n"
Red='\e[31m'; Green='\e[32m'; Yellow='\e[33m'; NoColor='\033[0m'

for f in ./outputs/spadesOut/*/contigs.fasta;
do
  # Naming inputs/ output
  out="${f:20:-16}";

  # # Drawing progress Bar
  # echo -n "["
  # for ((j=0; j<progress; j++)) ; do
  # if (( $i < ($res*1/3) )); then echo -ne "${Red}#${NoColor}"
  # elif (( $i < ($res*2/3) )); then echo -ne "${Yellow}#${NoColor}"
  # else echo -ne "${Green}#${NoColor}"; fi; done
  # for ((j=progress; j<50; j++)) ; do echo -ne ' '; done
  # echo -n "]  ($i/$res)  $out" $'\r'
  # ((i++)); progress=$(($i * 50 / $res ))

  # Writing run log
  echo "python3 ./python_scripts/cv_filter.py $f $1 $2" >> ./outputs/commands.log

  # Running cv_filter script
  python3 ./python_scripts/cv_filter.py $f $1 $2
done
