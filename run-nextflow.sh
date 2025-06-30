#!/usr/bin/env bash
# run-nextflow.sh - Script to run nextflow pipeline on SGE
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=8G
#$ -l rocky

source bash_functions.sh

USAGE="run-nextflow.sh [options] nextflow_pipeline_file"

OPTIONS="Options:
    -j    java version [default: 17.0.0]
    -o    Options [default: NULL]
    -p    Parameters [default: NULL]
    -r    Supply a name to resume a specific run of the pipeline. 
          To rerun the most recent one use "current".
    -d    Turn debugging on
    -h    print help info"

# default values
debug=0
JAVA_VERSION="17.0.0"
OPTIONS=""
PARAMS=""
RESUME=""
while getopts ":j:o:p:r:dh" opt; do
  case $opt in
    j)  JAVA_VERSION=$OPTARG  ;;
    o)  OPTIONS=$OPTARG ;;
    p)  PARAMS=$OPTARG ;;
    r)  RESUME=$OPTARG ;;
    d)  debug=1 ;;
    h)  usage "" ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

if [[ ! -z $RESUME ]]; then
  if [[ $RESUME == "current" ]]; then
    RESUME="-resume"
  else
    RESUME="-resume $RESUME"
  fi
fi

if [[ -z $1 ]]; then
  SCRIPT="main.nf"
else
  SCRIPT=$1
fi

CMD="nextflow run $OPTIONS $PARAMS $RESUME $SCRIPT"
if [[ $debug -gt 0 ]]; then
  echo $CMD >&2
fi
eval $CMD
SUCCESS=$?

verbose=1
error_checking $SUCCESS "job nextflow SUCCEEDED." "job nextflow FAILED: $SUCCESS"
exit $SUCCESS

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
