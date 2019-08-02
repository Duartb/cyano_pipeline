.PHONY: all clean

SAMP_1_READ := $(basename $(shell ls rawReads | head -1))
SAMP_1 := $(subst _R1_001,,$(SAMP_1_READ))

TRIM_LEFT := 17
TRIM_RIGHT = -5

MIN_QUALITY := 33
MIN_GC := 0.23
MAX_GC := 0.63

SHELL := /bin/bash
CONDAROOT := /home/dbalata/miniconda3

all: rawReads/$(SAMP_1_READ).fastq outputs/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html outputs/readsTrimmed/$(SAMP_1_READ)_trimmed.fastq \
	outputs/readsFiltered/$(SAMP_1_READ)_trimmed_filtered.fastq outputs/fastqcOut/finalReads/$(SAMP_1_READ)_trimmed_filtered_fastqc.html outputs/spadesOut/$(SAMP_1)/scaffolds.fasta \
	outputs/spadesOut/$(SAMP_1)/scaffolds.fasta outputs/quastOut/$(SAMP_1)/report.pdf outputs/coverages/$(SAMP_1)_cov.txt

# uses FastQC
outputs/fastqcOut/rawReads/%_fastqc.html: bash_scripts/auto_fastqc_raw.sh rawReads/%.fastq
	./bash_scripts/auto_fastqc_raw.sh

# uses CutAdapt
outputs/readsTrimmed/%_trimmed.fastq: ./bash_scripts/auto_trim.sh rawReads/%.fastq
	./bash_scripts/auto_trim.sh $(TRIM_LEFT) $(TRIM_RIGHT)

# uses BBDuk
outputs/readsFiltered/%_trimmed_filtered.fastq: ./bash_scripts/auto_filter.sh outputs/readsTrimmed/%_trimmed.fastq
	./bash_scripts/auto_filter.sh $(MIN_QUALITY) $(MIN_GC) $(MAX_GC)

# uses FastQC
outputs/fastqcOut/finalReads/%_trimmed_filtered_fastqc.html: ./bash_scripts/auto_fastqc_final.sh outputs/readsFiltered/%_trimmed_filtered.fastq
	./bash_scripts/auto_fastqc_final.sh

# uses Spades
outputs/spadesOut/%/scaffolds.fasta: ./bash_scripts/auto_spades.sh outputs/readsFiltered/%_R1_001_trimmed_filtered.fastq
	./bash_scripts/auto_spades.sh

# uses Quast
outputs/quastOut/%/report.pdf: ./bash_scripts/auto_quast.sh outputs/spadesOut/%/scaffolds.fasta
	./bash_scripts/auto_quast.sh

# uses BBMap
outputs/coverages/%_cov.txt: ./bash_scripts/auto_cov.sh outputs/spadesOut/*/scaffolds.fasta
	./bash_scripts/auto_cov.sh

clean:
	rm -r outputs
