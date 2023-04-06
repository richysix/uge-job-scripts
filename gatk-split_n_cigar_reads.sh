#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=4G

# gatk-split_n_cigar_reads.sh - Script to run GATK ASEReadCounter tool using UGE

source bash_functions.sh

USAGE="gatk-split_n_cigar_reads.sh [options] INPUT_BAM OUTPUT_BAM"

# default values
debug=0
verbose=1
REF_FILE="$SHARED/genomes/GRCz11/GRCz11.fa"

OPTIONS="Options:
	-r    reference fasta file [default: $REF_FILE]
	-d    print debugging info
	-q    turn off verbose output
	-h    print help info
"

while getopts ":r:dhv" opt; do
  case $opt in
    r)  REF_FILE=$OPTARG ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

# unpack arguments
INPUT_BAM=$1
OUTPUT_BAM=$2

module purge
module load GATK

CMD="gatk SplitNCigarReads \
--input $INPUT_BAM \
--output $OUTPUT_BAM \
--reference $REF_FILE"

if [[ $debug -gt 0 ]]; then
  echo "Command to run = $CMD"
fi

eval $CMD
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
