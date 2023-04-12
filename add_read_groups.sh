#!/usr/bin/env bash
# add_read_groups.sh - Script to add read groups to a bam file
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=100M

source bash_functions.sh

USAGE="add_read_groups.sh rg_tag in_bam out_bam"

OPTIONS="Options:
    -r    read group text
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
    h)  usage "" $USAGE $OPTIONS ;;
    q)  verbose=0 ;;
    v)  verbose=1 ;;
    \?) usage "Invalid option: -$OPTARG" $USAGE $OPTIONS ;;
    :)  usage "Option -$OPTARG requires an argument!" $USAGE $OPTIONS ;;
  esac
done
shift "$(($OPTIND -1))"

# unpack arguments
RG_TAG=$1
IN_BAM=$2
OUT_BAM=$3

module load samtools/1.17

samtools addreplacerg -r $RG_TAG -o $OUT_BAM $IN_BAM
SUCCESS=$?

error_checking $SUCCESS "job add_read_groups succeeded." "job add_read_groups failed: $SUCCESS"
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
