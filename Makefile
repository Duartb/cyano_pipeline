.PHONY: all clean fastqc_raw fastqc_final kraken quast rgi isfinder mauve clean

SHELL := /bin/bash
CONDAROOT := /home/dbalata/miniconda3

all: rawReads/*.fq fastqc_raw readsTrimmed/*_trimmed.fastq readsFiltered/*_filtered.fastq fastqc_final

rawReads/*.fq: rename.sh rawReads/*R1_001.fastq rawReads/*R2_001.fastq
	./rename.sh

# uses FastQC
fastqc_raw: auto_fastqc_raw.sh rawReads/*.fq
	./auto_fastqc_raw.sh

# uses CutAdapt
readsTrimmed/*_trimmed.fastq: rawReads/*.fq
	./auto_trim.sh

# uses BBDuk
readsFiltered/*_filtered.fastq: readsTrimmed/*_trimmed.fastq
	./auto_filter.sh

# uses FastQC
fastqc_final: readsFiltered/*_filtered.fastq
	./auto_fastqc_final.sh

clean:
	rm -r fastqc
