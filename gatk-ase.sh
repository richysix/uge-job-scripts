#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=2G

# gatk-ase.sh - Script to run GATK ASEReadCounter tool using UGE

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

USAGE="gatk-ase.sh [options] INPUT_FILE VCF_FILES"

# default values
debug=0
verbose=1
OUTPUT_FILE='ase-counts.tsv'
REF_FILE="$SHARED/genomes/GRCz11/GRCz11.fa"

OPTIONS="Options:
    -o    output file name [default: $OUTPUT_FILE]
    -r    reference fasta file [default: $REF_FILE]
    -d    print debugging info
    -q    quiet output
    -h    print help info"

while getopts "o:r:dhq" opt; do
  case $opt in
    o) OUTPUT_FILE=$OPTARG ;;
    r) REF_FILE=$OPTARG ;;
    d) debug=1 ;;
    h) echo ""; echo "$USAGE"; echo "$OPTIONS"; exit 1 ;;
    q) verbose=0 ;;
    \?) echo ""; echo "Invalid option: -$OPTARG" >&2; echo "$USAGE" >&2; echo "$OPTIONS" >&2; exit 1 ;;
    :)  echo ""; echo "Option -$OPTARG requires an argument!" >&2; echo "$USAGE" >&2; echo "$OPTIONS" >&2; exit 1 ;;
  esac
done
shift "$(($OPTIND -1))"

# unpack arguments
INPUT_FILE=$1
shift
VCF_FILES=$@
for file in ${VCF_FILES[@]}
do
  VAR_OPT_STRING="$VAR_OPT_STRING--variant $file "
done

if [[ $verbose -gt 0 ]]; then
  echo "Output file name = $OUTPUT_FILE
Genome reference file = $REF_FILE
Input file = $INPUT_FILE
vcf files = ${VCF_FILES[@]}"
fi

module purge
module load GATK

CMD="gatk ASEReadCounter \
-U ALLOW_N_CIGAR_READS \
--input $INPUT_FILE \
$VAR_OPT_STRING \
--output $OUTPUT_FILE \
--reference $REF_FILE"

if [[ $debug -gt 0 ]]; then
  echo "Command to run = $CMD"
fi

eval $CMD
