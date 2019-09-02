import sys
from sys import argv

File=argv[1]
print("Working on",File)

if len(argv)==5:
	with open(File) as infile:
		data=infile.readlines()
	length=argv[2]
	min_coverage=argv[3]
	max_coverage=argv[4]

else:
	with open(File) as infile:
		data=infile.readlines()
	length=argv[2]
	print("Retaining contigs of length "+str(length)+" and up.")
	min_coverage=eval(input("Enter the minimum contig min_coverage to retain: "))
	max_coverage=eval(input("Enter the maximum contig max_coverage to retain: "))

outfile=open(File.replace(".fasta","_filtered.fasta"),"w")
x=0
print("Working...")
while x < len(data):

	if ">" in data[x]:
		stats=data[x].split("_")
		if int(stats[3]) >= int(length) and float(stats[5]) >= float(min_coverage) and float(stats[5]) <= float(max_coverage):
			outfile.write(data[x])
			while ">" not in data[x+1]:
				x=x+1
				outfile.write(data[x])
	x=x+1

print("Done")
print("Filtered scaffolds output to the file: " + str(outfile))
outfile.close()
