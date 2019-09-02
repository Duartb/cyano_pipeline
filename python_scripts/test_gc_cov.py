#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 29 10:44:45 2019

@author: duartb
"""
import argparse
import numpy as np
from scipy.signal import argrelextrema


parser = argparse.ArgumentParser(prog='python3')

parser.add_argument("input_fasta", metavar="input.fasta", type=str,
                        help="fasta input file")
parser.add_argument("-o","--order", metavar="10",type=int, default=10,
                        help= "How many points on each side to use for the comparison to consider a relative maximum GC%")
parser.add_argument("-ml","--min_base_length", metavar="1000000",type=int, default=1000000,
                        help= "Minimum number of bases around the GC peak")

arguments = parser.parse_args()

print("\nRunning on " + arguments.input_fasta)
so = arguments.order

def Average(lst):
    return sum(lst) / len(lst)

fasta_file = open(arguments.input_fasta,"r")
gc_dict = {}
cov_set = set()

for line in fasta_file:
    if line.startswith(">"):
        line = line.split("_")
        cov = round(float(line[5]))

    else:
        if cov not in cov_set:
            gc_dict[cov] = line.strip()
            cov_set.add(cov)
        else:
            gc_dict[cov] += line.strip()

for i in gc_dict:
    length = len(gc_dict[i])
    gc = (gc_dict[i].count("G") + gc_dict[i].count("C")) / length
    gc_dict[i] = (length, gc)

gc_dict =  dict(sorted(gc_dict.items()))

coverages = list(gc_dict.keys())
lengths = [item[0] for item in list(gc_dict.values())]
gcs = [item[1] for item in list(gc_dict.values())]


peaks = argrelextrema(np.array(lengths), np.greater, order=so)
dips = argrelextrema(np.array(lengths), np.less, order=so)

for peak in peaks[0]:
    if peak < so:
        gc_around_peak = [gcs[i] for i in range(0,peak+so)]
        length_around_peak = [lengths[i] for i in range(0,peak+so)]
    elif peak + so > len(gcs):
        gc_around_peak = [gcs[i] for i in range(peak-so,len(gcs))]
        length_around_peak = [lengths[i] for i in range(peak-so,len(lengths))]
    else:
        gc_around_peak = [gcs[i] for i in range(peak-so,peak+so)]
        length_around_peak = [lengths[i] for i in range(peak-so,peak+so)]

    if sum(length_around_peak) > arguments.min_base_length:
        print ( "Coverage peak around " + str(coverages[peak]) + "x with an average GC% of " + str(round(Average(gc_around_peak),3)*100)[0:4] +
        "% and length of " + str(sum(length_around_peak)) + " bp")
