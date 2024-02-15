#!/usr/bin/env bash
# dump_exons_and_introns.sh - Script to output annotation as gff file
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=1G
#$ -o annotation.o
#$ -e annotation.e

module load Crispr/0.1.22

species=$1
outfile=$2
if [[ -n $outfile ]]; then
  out_option="--output_file $outfile"
else
  out_option=""
fi

dump_exons_and_introns.pl $out_option $species

module unload Crispr/0.1.22

# AUTHOR
#
# Richard White <rich@buschlab.org>
#
# COPYRIGHT AND LICENSE
#
# This software is Copyright (c) 2024. Queen Mary University of London.
#
# This is free software, licensed under:
#
#  The GNU General Public License, Version 3, June 2007
