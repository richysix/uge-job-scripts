#!/usr/bin/env bash
# run-topgo.sh - Script to run a TopGO enrichment
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=2G
#$ -t 1-10
#$ -l rocky

source bash_functions.sh

USAGE="run-topgo.sh [options] cmd_file"

OPTIONS="Options:
    -e    Ensembl version
    -d    print debugging info
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1
ENSEMBL_VERSION='99'
while getopts ":e:s:dhqv" opt; do
  case $opt in
    e)  ENSEMBL_VERSION=$OPTARG ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

module load topgo-wrapper/$ENSEMBL_VERSION

line=`sed "${SGE_TASK_ID}q;d" $in_file`
in_bam=`echo $line | awk '{ print $1 }'`
out_sam=`echo $line | awk '{ print $2 }'`
annotation=`echo $line | awk '{ print $3 }'`

# run script
run_topgo.pl \
--dir $dir --detct_file $file


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
# This software is Copyright (c) 2024. Queen Mary University of London.
#
# This is free software, licensed under:
#
#  The GNU General Public License, Version 3, June 2007
