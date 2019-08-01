.PHONY: all clean fastqc_raw fastqc_final kraken quast rgi isfinder mauve clean

SHELL := /bin/bash
CONDAROOT := /home/dbalata/miniconda3

all: rawReads/*.fq fastqc_raw outputs/readsTrimmed/*_trimmed.fastq outputs/readsFiltered/*_filtered.fastq fastqc_final \
	outputs/spadesOut/*/scaffolds.fasta quast

rawReads/*.fq: bash_scripts/rename.sh rawReads/*R1_001.fastq rawReads/*R2_001.fastq
	./bash_scripts/rename.sh

# uses FastQC
fastqc_raw: bash_scripts/auto_fastqc_raw.sh rawReads/*.fq
	./bash_scripts/auto_fastqc_raw.sh

# uses CutAdapt
outputs/readsTrimmed/*_trimmed.fastq: ./bash_scripts/auto_trim.sh rawReads/*.fq
	./bash_scripts/auto_trim.sh

# uses BBDuk
outputs/readsFiltered/*_filtered.fastq: ./bash_scripts/auto_filter.sh outputs/readsTrimmed/*_trimmed.fastq
	./bash_scripts/auto_filter.sh

# uses FastQC
fastqc_final: ./bash_scripts/auto_fastqc_final.sh outputs/readsFiltered/*_filtered.fastq
	./bash_scripts/auto_fastqc_final.sh

# uses Spades
outputs/spadesOut/*/scaffolds.fasta: ./bash_scripts/auto_spades.sh outputs/readsFiltered/*_filtered.fastq
	./bash_scripts/auto_spades.sh

# uses quast
quast: ./bash_scripts/auto_quast.sh outputs/spadesOut/*/scaffolds.fasta
	./bash_scripts/auto_quast.sh

clean:
	rm -r outputs
