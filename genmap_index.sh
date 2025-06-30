#!/usr/bin/env bash
# genmap_index.sh - Script to run GenMap to index a genome
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=12G
#$ -l rocky

USAGE="genmap_index.sh genome_fasta_file output_dir"

module load GenMap

genmap index -F $1 -I $2

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
