#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep  4 09:48:53 2019

@author: duartb
"""
import glob
import argparse

parser = argparse.ArgumentParser(prog='python3')

parser.add_argument("bins", metavar="/path/to/bins", type=str,
                        help="bins directory path")
parser.add_argument("ref_fasta", metavar="reference.fasta", type=str,
                        help="reference genome fasta file")
parser.add_argument("ref_stats", metavar="stats.txt", type=str,
                        help="reference genome stats file")
arguments = parser.parse_args()

def write_fasta_stats(ref_fasta_file, ref_stats_file):

    print("Generating reference genome stats file...")

    fasta=open(ref_fasta_file,"r")
    stats=open(ref_stats_file,"w")

    gc=0
    total_length=0

    for line in fasta:
        if line.startswith(">") == False:
            gc += line.count("G") + line.count("C")
            total_length += len(line)

    stats.write("gc_content\t" + str(round(gc / total_length * 100, 1)))
    stats.write("\n")
    stats.write("genome_size\t" + str(total_length))

    fasta.close()
    stats.close()

write_fasta_stats(arguments.ref_fasta, arguments.ref_stats)

def write_best_bins(path_to_bins, ref_stats_file):

    bins_file = path_to_bins + "/best_bins.txt"

    for line in open(ref_stats_file,"r"):
        line = line.split("\t")
        if line[0] == "gc_content":
            stats_gc = line[1]
        elif line[0] == "genome_size":
            stats_length = line[1]

    best_bins = []
    best_bins_file = open(bins_file,"w")

    print("Picking cianobacterial bins...")
    for file in glob.iglob(path_to_bins + "*.summary"):
        sample = (file.split("/")[-1].strip(".summary"))
        summary_file = open(file,"r")
        samples =[]; lengths = []; gcs = []; ponderations = []


        for line in summary_file:
            if line.startswith(sample):
                line = line.split("\t")
                samples.append(line[0])
                lengths.append(line[3])
                gcs.append(line[4])

        for sample, length, gc in zip(samples, lengths, gcs):
            ponderations.append(int(length)/int(stats_length) * 0.1 + float(gc)/float(stats_gc) * 0.9)

        best_fit = ponderations.index(min(ponderations, key=lambda x:abs(x-1)))
        best_bins.append(samples[best_fit])

    print("Generating best_bins.txt...")
    best_bins.sort()
    for b in best_bins:
        best_bins_file.write(b + "\n")

    best_bins_file.close()
    print("Done!")

write_best_bins(arguments.bins, arguments.ref_stats)
