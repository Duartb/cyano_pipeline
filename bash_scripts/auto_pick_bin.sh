set -e

mkdir -p ./outputs/finalGenomes

echo ""; printf "\nFinding cyanobacterial bins...:\n\n"

for file in ./refGenome/*.fasta
do
 ref=$file
done

echo -e "$(date) [PICK_BIN.PY] python3 ./python_scripts/pick_bin.py ./outputs/binned/ $ref ./refGenome/stats.txt" >> ./outputs/commands.log

python3 ./python_scripts/pick_bin.py ./outputs/binned/ $ref ./refGenome/stats.txt >> ./outputs/console.log 2>> ./outputs/console.log;

cat ./outputs/binned/best_bins.txt | while read line
do
   cp ./outputs/binned/${line} ./outputs/finalGenomes/
done
