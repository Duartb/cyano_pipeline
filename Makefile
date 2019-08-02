.PHONY: all clean explore improve_reads assemble assemply_quality

SAMP_1_READ := $(basename $(shell ls rawReads | head -1))
SAMP_1 := $(subst _R1_001,,$(SAMP_1_READ))

# Select the amount of bases to cut from the ends of each read using CutAdapt (tip: adjust after using 'make explore')
TRIM_LEFT := 17
TRIM_RIGHT = -5

# Select minimum allowed avg quality of each read and minimum and maximum %GC using BBDuk (tip: adjust after using 'make explore')
MIN_QUALITY := 33
MIN_GC := 0.23
MAX_GC := 0.63

# Select the number of threads used to run every program that support multithreading
THREADS := 8

SHELL := /bin/bash

all: outputs/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html outputs/readsTrimmed/$(SAMP_1_READ)_trimmed.fastq \
	outputs/readsFiltered/$(SAMP_1_READ)_trimmed_filtered.fastq outputs/fastqcOut/finalReads/$(SAMP_1_READ)_trimmed_filtered_fastqc.html outputs/krakenOut/$(SAMP_1).report \
	outputs/spadesOut/$(SAMP_1)/scaffolds.fasta outputs/spadesOut/$(SAMP_1)/scaffolds.fasta outputs/quastOut/$(SAMP_1)/report.pdf outputs/coverages/$(SAMP_1)_cov.txt

explore: outputs/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html

improve_reads: outputs/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html outputs/readsTrimmed/$(SAMP_1_READ)_trimmed.fastq \
	outputs/readsFiltered/$(SAMP_1_READ)_trimmed_filtered.fastq outputs/fastqcOut/finalReads/$(SAMP_1_READ)_trimmed_filtered_fastqc.html

assemble: outputs/readsTrimmed/$(SAMP_1_READ)_trimmed.fastq outputs/readsFiltered/$(SAMP_1_READ)_trimmed_filtered.fastq outputs/spadesOut/$(SAMP_1)/scaffolds.fasta

assemply_quality: outputs/quastOut/$(SAMP_1)/report.pdf outputs/coverages/$(SAMP_1)_cov.txt

# RULES

# uses FastQC to analyse the raw reads
outputs/fastqcOut/rawReads/%_fastqc.html: bash_scripts/auto_fastqc_raw.sh rawReads/%.fastq
	./bash_scripts/auto_fastqc_raw.sh $(THREADS)

# uses CutAdapt to cut the ends of the raw reads
outputs/readsTrimmed/%_trimmed.fastq: ./bash_scripts/auto_trim.sh rawReads/%.fastq
	./bash_scripts/auto_trim.sh $(TRIM_LEFT) $(TRIM_RIGHT)

# uses BBDuk filter the raw reads based on quality and %GC
outputs/readsFiltered/%_trimmed_filtered.fastq: ./bash_scripts/auto_filter.sh outputs/readsTrimmed/%_trimmed.fastq
	./bash_scripts/auto_filter.sh $(MIN_QUALITY) $(MIN_GC) $(MAX_GC) $(THREADS)

# uses FastQC to analyse the final reads
outputs/fastqcOut/finalReads/%_trimmed_filtered_fastqc.html: ./bash_scripts/auto_fastqc_final.sh outputs/readsFiltered/%_trimmed_filtered.fastq
	./bash_scripts/auto_fastqc_final.sh $(THREADS)

# uses Kraken2 create a taxonomy classification of the present species (from the final reads)
outputs/krakenOut/%.report: ./bash_scripts/auto_kraken.sh ./outputs/readsFiltered/%_R1_001_trimmed_filtered.fastq
	./bash_scripts/auto_kraken.sh $(THREADS)

# uses Spades to assemble the final reads
outputs/spadesOut/%/scaffolds.fasta: ./bash_scripts/auto_spades.sh outputs/readsFiltered/%_R1_001_trimmed_filtered.fastq
	./bash_scripts/auto_spades.sh $(THREADS)

# uses Quast to analyse Spades' assembly quality
outputs/quastOut/%/report.pdf: ./bash_scripts/auto_quast.sh outputs/spadesOut/%/scaffolds.fasta
	./bash_scripts/auto_quast.sh $(THREADS)

# uses BBMap to get the genome coverage
outputs/coverages/%_cov.txt: ./bash_scripts/auto_cov.sh outputs/spadesOut/%/scaffolds.fasta
	./bash_scripts/auto_cov.sh $(THREADS)

clean:
	rm -r outputs
