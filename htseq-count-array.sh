#!/usr/bin/env bash
# htseq-count-array.sh - UGE script to run htseq-count as an array job
# expects a file with up to 3 columns
# Name of input bam file
# Name of output sam file. The sam file contains a flag to indicate whether or
# not the read was counted and if not, why not 
# Name of annotation GTF file to use
# If using a custom GTF file but you don't want an output sam file, set the
# second column to NULL
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=1G
#$ -t 1-96

source bash_functions.sh

USAGE="htseq-count-array.sh [options] input_file"

OPTIONS="Options:
    -d    print debugging info
    -v    verbose output
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1

while getopts ":dhqv" opt; do
  case $opt in
    d)  debug=1  ;;
    h)  usage "" ;;
    v)  verbose=1 ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

# unpack arguments
in_file=$1
line=`sed "${SGE_TASK_ID}q;d" $in_file`
in_bam=`echo $line | awk '{ print $1 }'`
out_sam=`echo $line | awk '{ print $2 }'`
annotation=`echo $line | awk '{ print $3 }'`

if [[ $debug -eq 1 ]]; then
    echo $in_bam $out_sam $annotation
fi
if [[ $out_sam == "NULL" ]]; then
    out_sam=""
fi

CMD="sh htseq-count.sh"
if [[ ! -z $out_sam ]]; then
    CMD="$CMD -s $out_sam"
fi
if [[ ! -z $annotation ]]; then
    CMD="$CMD -g $annotation"
fi
CMD="$CMD $in_bam"

eval $CMD
SUCCESS=$?

error_checking $SUCCESS "job htseq-count, task ${SGE_TASK_ID} SUCCEEDED." "job htseq-count, task ${SGE_TASK_ID} FAILED: $SUCCESS"

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
