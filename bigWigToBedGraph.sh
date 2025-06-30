#!/usr/bin/env bash
# bigWigToBedGraph.sh - Script to run bigWigToBedGraph
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=300M
#$ -l rocky

bigWigToBedGraph $1 $2

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
