.PHONY: all clean fastqc_raw fastqc_final kraken quast rgi isfinder mauve clean

SHELL := /bin/bash

all: rawReads/*.fq fastqc_raw readsTrimmed/*_trimmed.fastq readsFiltered/*_filtered.fastq fastqc_final

rawReads/*.fq: rename.sh raw/*R1_001.fastq raw/*R2_001.fastq
	./rename.sh

# uses FastQC
fastqc_raw: auto_fastqc_raw.sh raw/*.fq
	conda activate fastqc_env
	./auto_fastqc_raw.sh
	conda deactivate

# uses CutAdapt
readsTrimmed/*_trimmed.fastq: raw/*.fq
	conda activate cutadapt_env
	./auto_trim.sh
	conda deactivate

# uses BBDuk
readsFiltered/*_filtered.fastq: readsTrimmed/*_trimmed.fastq
	./auto_filter.sh

# uses FastQC
fastqc_final: readsFiltered/*_filtered.fastq
	conda activate fastqc_env
	./auto_fastqc_final.sh
	conda deactivate

clean:
	rm -r fastqc
