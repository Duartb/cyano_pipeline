.PHONY: all clean rename fastqc_raw fastqc_final kraken quast rgi isfinder mauve clean

SHELL := /bin/bash

#all: %.fq fastqc_raw %_trimmed.fastq %_trimmed_filtered.fastq fastqc_final kraken %.fasta quast rgi isfinder mauve

raw/*.fq: raw/*R1_001.fastq raw/*R2_001.fastq
	./rename.sh

clean:
	rm -r fastqc
