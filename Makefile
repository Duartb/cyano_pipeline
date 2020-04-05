SHELL:=/bin/bash

.PHONY: all clean clean_intermediate read_quality binning final_taxonomy mapping

# Select the amount of bases to cut from the ends of each read using CutAdapt (tip: adjust after using 'make read_quality')
TRIM_LEFT := 17
TRIM_RIGHT := -5

# Select minimum allowed avg quality of each read and minimum and maximum %GC using BBDuk (tip: adjust after using 'make read_quality')
MIN_QUALITY := 33

# Select the number of threads used to run every program that supports multithreading
THREADS := 6

# Select which Kraken database to use (kraken_standard or kraken_silva_16s)
KRAKEN_DB := kraken_silva_16s

SAMP_1_READ := $(basename $(shell ls $(FASTQ_DIR) | head -1))
SAMP_1 := $(subst _R1_001,,$(SAMP_1_READ))
SAMP_1_BIN := $(subst _R1_001,.001,$(SAMP_1_READ))

all: $(OUTPUT_DIR)/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html $(OUTPUT_DIR)/readsTrimmed/$(SAMP_1_READ)_trimmed.fastq \
	$(OUTPUT_DIR)/readsFiltered/$(SAMP_1_READ)_trimmed_filtered.fastq $(OUTPUT_DIR)/fastqcOut/finalReads/$(SAMP_1_READ)_trimmed_filtered_fastqc.html \
	$(OUTPUT_DIR)/krakenOut/raw/reports/$(SAMP_1).report $(OUTPUT_DIR)/spadesOut/$(SAMP_1)/contigs.fasta $(OUTPUT_DIR)/binned/$(SAMP_1).001.fasta $(OUTPUT_DIR)/binned/best_bins.txt \
	$(OUTPUT_DIR)/quastOut/$(SAMP_1_BIN)/report.pdf $(OUTPUT_DIR)/krakenOut/final/reports/$(SAMP_1_BIN).report

read_quality: $(OUTPUT_DIR)/fastqcOut/rawReads/$(SAMP_1_READ)_fastqc.html

binning: $(OUTPUT_DIR)/binned/$(SAMP_1).001.fasta

final_taxonomy: $(OUTPUT_DIR)/krakenOut/final/reports/$(SAMP_1_BIN).report

mapping: $(OUTPUT_DIR)/coverages/$(SAMP_1)_cov.txt


# RULES

# uses FastQC to analyse the raw reads
$(OUTPUT_DIR)/fastqcOut/rawReads/%_fastqc.html: bash_scripts/auto_fastqc_raw.sh $(FASTQ_DIR)/%.fastq
	@./bash_scripts/auto_fastqc_raw.sh $(FASTQ_DIR) $(OUTPUT_DIR) $(THREADS)

# uses CutAdapt to cut the ends of the raw reads
$(OUTPUT_DIR)/readsTrimmed/%_trimmed.fastq: ./bash_scripts/auto_trim.sh $(FASTQ_DIR)/%.fastq
	@./bash_scripts/auto_trim.sh $(FASTQ_DIR) $(OUTPUT_DIR) $(TRIM_LEFT) $(TRIM_RIGHT)

# uses BBDuk filter the raw reads based on quality and %GC
$(OUTPUT_DIR)/readsFiltered/%_trimmed_filtered.fastq: ./bash_scripts/auto_filter.sh $(OUTPUT_DIR)/readsTrimmed/%_trimmed.fastq
	@./bash_scripts/auto_filter.sh $(OUTPUT_DIR) $(MIN_QUALITY) $(THREADS)

# uses FastQC to analyse the final reads
$(OUTPUT_DIR)/fastqcOut/finalReads/%_trimmed_filtered_fastqc.html: ./bash_scripts/auto_fastqc_final.sh $(OUTPUT_DIR)/readsFiltered/%_trimmed_filtered.fastq
	@./bash_scripts/auto_fastqc_final.sh $(OUTPUT_DIR) $(THREADS)

# uses Kraken2 create a taxonomy classification of the present species (from the final reads)
$(OUTPUT_DIR)/krakenOut/raw/reports/%.report: ./bash_scripts/auto_kraken_raw.sh $(OUTPUT_DIR)/readsFiltered/%_R1_001_trimmed_filtered.fastq
	@./bash_scripts/auto_kraken_raw.sh $(OUTPUT_DIR) $(KRAKEN_DB) $(THREADS)

# uses Spades to assemble the final reads
$(OUTPUT_DIR)/spadesOut/%/contigs.fasta: ./bash_scripts/auto_spades.sh $(OUTPUT_DIR)/readsFiltered/%_R1_001_trimmed_filtered.fastq
	@./bash_scripts/auto_spades.sh $(OUTPUT_DIR) $(THREADS)

# uses MaxBin2 to bin the contigs produced from the spades metagenomic assembly
$(OUTPUT_DIR)/binned/%.001.fasta: ./bash_scripts/auto_maxbin.sh $(wildcard $(OUTPUT_DIR)/spadesOut/%/contigs.fasta)
	@./bash_scripts/auto_maxbin.sh $(OUTPUT_DIR) $(THREADS)

# uses a custom script to choose what bin has the biggest probability of corresponding to the species of interest
$(OUTPUT_DIR)/binned/best_bins.txt: ./bash_scripts/auto_pick_bin.sh ./python_scripts/pick_bin.py $(wildcard $(OUTPUT_DIR)/binned/*.001.fasta)
	@./bash_scripts/auto_pick_bin.sh $(OUTPUT_DIR) $(REF)

# uses Quast to analyse Spades' assembly quality post binning
$(OUTPUT_DIR)/quastOut/%/report.pdf: ./bash_scripts/auto_quast.sh $(OUTPUT_DIR)/binned/%.fasta
	@./bash_scripts/auto_quast.sh $(OUTPUT_DIR) $(THREADS)

$(OUTPUT_DIR)/krakenOut/final/reports/%.report: ./bash_scripts/auto_kraken_final.sh $(OUTPUT_DIR)/binned/%.fasta
	@./bash_scripts/auto_kraken_final.sh $(OUTPUT_DIR) $(KRAKEN_DB) $(THREADS)

# uses BBMap to get the genome coverage
$(OUTPUT_DIR)/coverages/%_cov.txt: ./bash_scripts/auto_map.sh $(wildcard $(OUTPUT_DIR)/spadesOut/%/contigs.fasta)
	@./bash_scripts/auto_map.sh $(OUTPUT_DIR) $(THREADS)

clean:
	rm -r $(OUTPUT_DIR)

clean_intermediate:
	rm -r $(OUTPUT_DIR)/fastqcOut/rawReads/
	rm -r $(OUTPUT_DIR)/readsTrimmed/
	rm -r $(FASTQ_DIR)/*_R1R2.fastq
	rm -r $(OUTPUT_DIR)/krakenOut/raw/
	rm -r $(OUTPUT_DIR)/quastOut/*_001/
