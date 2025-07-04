#!/usr/bin/env bash
# gatk-split_n_cigar_reads-array.sh - Script to run GATK SplitNCigarReads as an array job
# see gatk-split_n_cigar_reads.sh for details
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=4G
#$ -t 1-96
#$ -l rocky

USAGE="gatk-split_n_cigar_reads-array.sh"

source bash_functions.sh

line=`sed "${SGE_TASK_ID}q;d" bams.tsv`
in_bam=`echo $line | awk '{ print $1 }'`
out_bam=`echo $line | awk '{ print $2 }'`
ref=`echo $line | awk '{ print $3 }'`
if [[ -z $ref ]]; then
    REF=""
else
    REF="-r $ref"
fi

../scripts/gatk-split_n_cigar_reads.sh -q $REF $in_bam $out_bam
SUCCESS=$?

error_checking $SUCCESS "job ${JOB_NAME} ${SGE_TASK_ID} succeeded" "job ${JOB_NAME} ${SGE_TASK_ID} failed: $SUCCESS"

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
