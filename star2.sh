#!/usr/bin/env bash
# star2.sh - Script to run STAR on a set of FASTQ files
# expects a file name fastq.tsv to exist in the working directory
# This should contains three columns
# sample names
# comma-separated list of read1 fastq filenames
# comma-separated list of read2 fastq filenames
# This script is for the second pass of the two-pass mapping strategy with STAR
# The results of the first pass should be in a directory names star1
# Input to the script is a line number to index into the fastq.tsv file
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=24G

USAGE="star2.sh [options] sample fastq1 fastq2"

source bash_functions.sh

OPTIONS="Options:
    -t    turn on TranscriptomeSAM quant mode
    -d    print debugging info
    -v    verbose output
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1
transcriptomeSAM=""

while getopts ":tdhqv" opt; do
  case $opt in
    t)  transcriptomeSAM='transcriptomeSAM' ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    q)  verbose=0 ;;
    v)  verbose=1 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

# unpack arguments
sample=$1
fastq1=$2
fastq2=$3

mkdir -p $sample

module load STAR
STAR \
--runThreadN 1 \
--genomeDir ../reference/grcz11 \
--readFilesIn $fastq1 $fastq2 \
--readFilesCommand zcat \
--outFileNamePrefix $sample/ \
--quantMode $transcriptomeSAM GeneCounts \
--outSAMtype BAM SortedByCoordinate \
--sjdbFileChrStartEnd `find ../star1 | grep SJ.out.tab$ | sort | tr '\n' ' '`

SUCCESS=$?
error_checking $SUCCESS "job star2 SUCCEEDED." "job star2 FAILED: $SUCCESS"
exit $SUCCESS

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
