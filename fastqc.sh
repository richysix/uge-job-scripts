#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=1:0:0
#$ -l h_vmem=275M

# AUTHOR
#
# Richard White <rich@buschlab.org>
#
# COPYRIGHT AND LICENSE
#
# This software is Copyright (c) 2023. Queen Mary University of London.
#
# This is free software, licensed under:
#
#  The GNU General Public License, Version 3, June 2007

module load FastQC

fastqc --quiet --threads 12 --noextract *.fastq.gz

## TO DO
# Make -t an option to set the number of threads
