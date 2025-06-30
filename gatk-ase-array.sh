#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=4.4G
#$ -t 1
#$ -l rocky

# gatk-ase-array.sh - Script to run GATK ASEReadCounter tool using UGE

USAGE="gatk-ase-array.sh [options] FILE"

source bash_functions.sh

# default values
debug=0
verbose=1

OPTIONS="Options:
    -r    Genome reference file
    -d    print debugging info
    -v    verbose output [default]
    -q    quiet output
    -h    print help info"

while getopts ":r:dvqh" opt; do
  case $opt in
    r) REF_FILE=$OPTARG ;;
    d) debug=1 ;;
    v) verbose=1 ;;
    q) verbose=0 ;;
    h)  usage "" ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

# unpack arguments
line=`sed "${SGE_TASK_ID}q;d" $1`
INPUT_FILE=`echo $line | awk '{ print $1 }'`
VCF_FILES=`echo $line | awk '{ print $2 }'`
OUTPUT_FILE=`echo $line | awk '{ print $3 }'`

if [[ -z $OUTPUT_FILE ]]; then OUTPUT_FILE="ase-counts.${SGE_TASK_ID}.tsv" ; fi
if [[ -z $REF_FILE ]]; then REF_FILE="$SHARED/genomes/GRCz11/GRCz11.fa" ; fi

if [[ $verbose -gt 0 ]]; then
  echo "Output file name = $OUTPUT_FILE
Input file = $INPUT_FILE
vcf files = $VCF_FILES
Genome reference file = $REF_FILE
"
fi

module purge
module load GATK

CMD="gatk --java-options '-Xms2G -Xmx4G' ASEReadCounter \
--input $INPUT_FILE \
--variant $VCF_FILES \
--output $OUTPUT_FILE \
--reference $REF_FILE"

if [[ $debug -gt 0 ]]; then
  echo "Command to run = $CMD"
fi

eval $CMD
SUCCESS=$?

error_checking $SUCCESS "job gatk-ase:${SGE_TASK_ID} succeeded." "job gatk-ase:task ${SGE_TASK_ID} failed. Exit code = $SUCCESS"
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
