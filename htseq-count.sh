#!/usr/bin/env bash
# htseq-count.sh - Run HTSeq-count on a bam file
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=1G
#$ -l rocky

source bash_functions.sh

USAGE="program_name.sh [options] bam_file"

OPTIONS="Options:
    -g    GTF file of annotation 
    -s    Output name for SAM file
    -d    print debugging info
    -v    verbose output
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1
GTF_FILE=$SHARED/genomes/GRCz11/STAR/Danio_rerio.GRCz11.109.gtf
SAM_FILE=""
while getopts ":g:s:dhqv" opt; do
  case $opt in
    g)  GTF_FILE=$OPTARG  ;;
    s)  SAM_FILE=$OPTARG  ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    v)  verbose=1 ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

if [[ -z $SAM_FILE ]]; then
    SAM_OPT=""
else
    SAM_OPT="--samout $SAM_FILE"
fi
# unpack arguments
bam_file=$1
counts_file=$( basename $bam_file .bam | sed -e 's|$|.count|' )

module load HTSeq
htseq-count \
--mode union \
--format bam \
--order pos \
--stranded reverse \
--type exon \
--idattr gene_id \
--additional-attr gene_name \
--nonunique none \
--secondary-alignments ignore \
--supplementary-alignments ignore \
$SAM_OPT \
$bam_file $GTF_FILE > $counts_file
SUCCESS=$?

# turn sam file into bam file
if [[ ! -z $SAM_FILE ]]; then
    module load samtools/1.17
    OUT_FILE=$( echo $SAM_FILE | sed -e 's|\.sam|.bam|')
    HEADER_FILE=$( basename $bam_file .bam | sed -e 's|$|.header|' )
    samtools view --header-only $bam_file > $HEADER_FILE
    cat $HEADER_FILE $SAM_FILE | samtools view -b --output $OUT_FILE
    SUCCESS=$?
    error_checking $SUCCESS "Converting sam file to bam file SUCCEEDED." "Converting sam file to bam file FAILED: $SUCCESS"
    rm $SAM_FILE $HEADER_FILE
fi

error_checking $SUCCESS "job ht-seq SUCCEEDED." "job ht-seq FAILED: $SUCCESS"
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
