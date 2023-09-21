#!/usr/bin/env bash
# rscript-array.sh - Script to run a file of Rscript commands as an array job
# It loads the R module and then runs a single line based on the TASK_ID
# from a supplied file. Filename is the argument to the script.
# The second argument is an optional job name for the success/failure message
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=2G
#$ -t 1-10

source bash_functions.sh

USAGE="rscript-array.sh [options] file job_name"

OPTIONS="Options:
    -r    R version
    -d    print debugging info
    -v    verbose output
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1
R_VERSION=4.2.1
while getopts ":r:dhqv" opt; do
  case $opt in
    r)  R_VERSION=$OPTARG  ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    v)  verbose=1 ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

R_VERSION=$( echo $R_VERSION | sed -e 's|^R/||' )
module load R/$R_VERSION

if [[ -z $2 ]]; then
    JOB=${JOB_NAME}
else
    JOB=$2
fi

if [[ $debug -gt 0 ]]; then
    echo "R version = $R_VERSION
Input file: $1
Job name: $JOB"
fi

line=`sed "${SGE_TASK_ID}q;d" $1`
eval $line
SUCCESS=$?

verbose=1
error_checking $SUCCESS "job ${JOB}, task ${SGE_TASK_ID} SUCCEEDED." "job ${JOB}, task ${SGE_TASK_ID} FAILED: $SUCCESS"
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
