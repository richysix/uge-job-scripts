#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=1:0:0
#$ -l h_vmem=275M

module load FastQC

fastqc --quiet --threads 12 --noextract *.fastq.gz

fastqc_error=$?
if [[ $fastqc_error -gt 0 ]]; then
    echo "FASTQC FAILED" 1>&2
    exit $fastqc_error
fi

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

