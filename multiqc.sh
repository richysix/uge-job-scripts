#!/usr/bin/env bash
# multiqc.sh - Description
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=100M

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

module load MultiQC/1.10.1

multiqc --file-list multiqc-input.txt --sample-names multiqc-samples.txt -m fastqc
