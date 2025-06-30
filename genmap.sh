#!/usr/bin/env bash
# genmap.sh - Script to run GenMap to index a genome
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=240:0:0
#$ -l h_vmem=1G
#$ -l rocky

USAGE="genmap.sh [options] genome_index_dir output_dir"

OPTIONS="Options:
    -k    Read length
    -e    Number of mismatches
    -d    print debugging info
    -h    print help info"

# default values
debug=0
READ_LENGTH=75
MISMATCHES=2

while getopts "k:e:dh" opt; do
  case $opt in
    k)
      READ_LENGTH=$OPTARG
      ;;
    e)
      MISMATCHES=$OPTARG
      ;;
    d)
      debug=1
      ;;
    h)
      echo ""
      echo "$USAGE"
      echo "$OPTIONS"
      exit 1
      ;;
    \?)
      echo ""
      echo "Invalid option: -$OPTARG" >&2
      echo "$USAGE" >&2
      echo "$OPTIONS" >&2
      exit 1
      ;;
    :)
      echo ""
      echo "Option -$OPTARG requires an argument!" >&2
      echo "$USAGE" >&2
      echo "$OPTIONS" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

module load GenMap

genmap map -T 8 -K $READ_LENGTH -E $MISMATCHES -I $1 -O $2 -t -w -bg

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
