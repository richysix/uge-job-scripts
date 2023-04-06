#!/usr/bin/env bash
# samtools_index.sh - Script to index bam files with samtools
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=100M

source bash_functions.sh

USAGE="samtools_index.sh -M [options] in1.bam in2.bam ...
or samtools_index.sh [options] in.bam [out.index]"

OPTIONS="Options:
    -M    Interpret all filename arguments as files to be indexed
    -d    print debugging info
    -q    Turn off verbose output
    -h    print help info"

# default values
debug=0
verbose=1
mode=''

while getopts ":Mdhq" opt; do
  case $opt in
    M)  mode="-M" ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

module load samtools/1.17

samtools index $mode $@
SUCCESS=$?

error_checking $SUCCESS "job ${JOB_NAME} succeeded" "job ${JOB_NAME} failed: $SUCCESS"

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
