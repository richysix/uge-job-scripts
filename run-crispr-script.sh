#!/usr/bin/env bash
# run-crispr-script.sh - Script to find and score CRISPR gRNA sites
# for a set of targets
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=4G
#$ -o crRNA-scored.o
#$ -e crRNA-scored.e
#$ -l rocky

source bash_functions.sh

USAGE="run-crispr-script.sh cmd_file"

OPTIONS="Options:
    -c    Crispr module version number [defaul: 0.1.22]
    -d    print debugging info
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1
CRISPR_VERSION='0.1.22'

while getopts ":c:dhq" opt; do
  case $opt in
    c)  CRISPR_VERSION=$OPTARG ;;
    d)  debug=1  ;;
    h)  usage "" $USAGE $OPTIONS ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" $USAGE $OPTIONS ;;
    :)  usage "Option -$OPTARG requires an argument!" $USAGE $OPTIONS ;;
  esac
done
shift "$(($OPTIND -1))"

module load Crispr/$CRISPR_VERSION

CMD=`sed "1q;d" $1`
eval $CMD
SUCCESS=$?

error_checking $SUCCESS "job run-crispr-script succeeded." "job run-crispr-script failed: $SUCCESS"
exit $SUCCESS

module unload Crispr/$CRISPR_VERSION

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
