#!/usr/bin/env bash
# star2-array.sh - Script to run STAR as an array job
# see star2.sh for details
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=24G
#$ -t 1-96

USAGE="star2-array.sh"

star2.sh ${SGE_TASK_ID}

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
