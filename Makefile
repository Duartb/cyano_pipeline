.PHONY: all clean clean_intermediate read_quality 

SAMP_1_READ := $(basename $(shell ls rawReads | head -1))
SAMP_1 := $(subst _R1_001,,$(SAMP_1_READ))
SAMP_1_BIN := $(subst _R1_001,.001,$(SAMP_1_READ))

# Select the amount of bases to cut from the ends of each read using CutAdapt (tip: adjust after using 'make read_quality')
TRIM_LEFT := 17
TRIM_RIGHT = -5

# Select minimum allowed avg quality of each read and minimum and maximum %GC using BBDuk (tip: adjust after using 'make read_quality')
MIN_QUALITY := 33

# Select the number of threads used to run every program that supports multithreading
THREADS := 6

SHELL := /bin/bash

all: outputs/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html outputs/readsTrimmed/$(SAMP_1_READ)_trimmed.fastq outputs/krakenOut/raw/$(SAMP_1).report\
	outputs/readsFiltered/$(SAMP_1_READ)_trimmed_filtered.fastq outputs/fastqcOut/finalReads/$(SAMP_1_READ)_trimmed_filtered_fastqc.html \
	outputs/spadesOut/$(SAMP_1)/contigs.fasta ./outputs/binned/$(SAMP_1).001.fasta ./outputs/binned/best_bins.txt\
	outputs/quastOut/$(SAMP_1_BIN)/report.pdf outputs/krakenOut/final/reports/$(SAMP_1_BIN).report

read_quality: outputs/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html

# RULES

# uses FastQC to analyse the raw reads
outputs/fastqcOut/rawReads/%_fastqc.html: bash_scripts/auto_fastqc_raw.sh rawReads/%.fastq
	@./bash_scripts/auto_fastqc_raw.sh $(THREADS)

# uses CutAdapt to cut the ends of the raw reads
outputs/readsTrimmed/%_trimmed.fastq: ./bash_scripts/auto_trim.sh rawReads/%.fastq
	@./bash_scripts/auto_trim.sh $(TRIM_LEFT) $(TRIM_RIGHT)

# uses Kraken2 create a taxonomy classification of the present species (from the final reads)
outputs/krakenOut/raw/%.report: ./bash_scripts/auto_kraken_raw.sh ./rawReads/%_R1_001.fastq
	@./bash_scripts/auto_kraken_raw.sh $(THREADS)

# uses BBDuk filter the raw reads based on quality and %GC
outputs/readsFiltered/%_trimmed_filtered.fastq: ./bash_scripts/auto_filter.sh outputs/readsTrimmed/%_trimmed.fastq
	@./bash_scripts/auto_filter.sh $(MIN_QUALITY) $(THREADS)

# uses FastQC to analyse the final reads
outputs/fastqcOut/finalReads/%_trimmed_filtered_fastqc.html: ./bash_scripts/auto_fastqc_final.sh outputs/readsFiltered/%_trimmed_filtered.fastq
	@./bash_scripts/auto_fastqc_final.sh $(THREADS)

# uses Spades to assemble the final reads
outputs/spadesOut/%/contigs.fasta: ./bash_scripts/auto_spades.sh outputs/readsFiltered/%_R1_001_trimmed_filtered.fastq
	@./bash_scripts/auto_spades.sh $(THREADS)

# uses MaxBin2 to bin the contigs produced from the spades metagenomic assembly
outputs/binned/%.001.fasta: ./bash_scripts/auto_maxbin.sh $(wildcard outputs/spadesOut/%/contigs_filtered.fasta)
	@./bash_scripts/auto_maxbin.sh $(THREADS)

# uses a custom script to choose what bin has the biggest probability of corresponding to the species of interest
outputs/binned/best_bins.txt: ./bash_scripts/auto_pick_bin.sh ./python_scripts/pick_bin.py $(wildcard ./outputs/binned/*.001.fasta)
	@./bash_scripts/auto_pick_bin.sh

# uses Quast to analyse Spades' assembly quality post binning
outputs/quastOut/%/report.pdf: ./bash_scripts/auto_quast.sh ./outputs/binned/%.fasta
	@./bash_scripts/auto_quast.sh $(THREADS)

outputs/krakenOut/final/reports/%.report: ./bash_scripts/auto_kraken_final.sh ./outputs/binned/%.fasta
	@./bash_scripts/auto_kraken_final.sh $(THREADS)

# uses BBMap to get the genome coverage
outputs/coverages/%_cov.txt: ./bash_scripts/auto_cov.sh ./outputs/finalGenomes/%.fasta
	@./bash_scripts/auto_cov.sh $(THREADS)

clean:
	rm -r outputs

clean_intermediate:
	rm -r outputs/fastqcOut/rawReads/
	rm -r outputs/readsTrimmed/
	rm -r rawReads/*_R1R2.fastq
	rm -r outputs/krakenOut/raw/
	rm -r outputs/quastOut/*_001/
