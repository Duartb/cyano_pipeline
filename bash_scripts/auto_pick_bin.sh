set -e

mkdir -p $1/finalGenomes

echo ""; printf "\nFinding cyanobacterial bins...:\n\n"

for file in $2/*.fasta
do
 ref=$file
done

echo -e "$(date) [PICK_BIN.PY] python3 ./python_scripts/pick_bin.py $1/binned/ $ref $2/stats.txt" >> $1/commands.log

python3 ./python_scripts/pick_bin.py $1/binned/ $ref $2/stats.txt >> $1/console.log 2>> $1/console.log;

cat $1/binned/best_bins.txt | while read line
do
   cp $1/binned/${line} $1/finalGenomes/
done
