#!/usr/bin/env bash
# star2-array.sh - Script to run STAR as an array job
# see star2.sh for details
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=24G
#$ -t 1-96
#$ -l rocky

USAGE="star2-array.sh [options]"

source bash_functions.sh

OPTIONS="Options:
    -t    turn on TranscriptomeSAM quant mode
    -d    print debugging info"

# default values
debug=0
t=""

while getopts ":td" opt; do
  case $opt in
    t)  t="-t" ;;
    d)  debug=1  ;;
  esac
done
shift "$(($OPTIND -1))"

# expects a file named fastq.tsv
if [[ ! -e fastq.tsv ]]; then
    echo "File fastq.tsv not found!"
    exit 2
fi

line=`sed "${SGE_TASK_ID}q;d" fastq.tsv`
sample=`echo $line | awk '{ print $1 }'`
fastq1=`echo $line | awk '{ print $2 }'`
fastq2=`echo $line | awk '{ print $3 }'`

if [[ $debug -eq 1 ]]; then
    echo $t $sample $fastq1 $fastq2
fi

sh star2.sh -q $t $sample $fastq1 $fastq2
SUCCESS=$?

verbose=1
error_checking $SUCCESS "job star2, task ${SGE_TASK_ID} SUCCEEDED." "job star2, task ${SGE_TASK_ID} FAILED: $SUCCESS"

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
