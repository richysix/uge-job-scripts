#!/usr/bin/env bash
# add_read_groups-array.sh - Description
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=100M
#$ -t 1-10

source bash_functions.sh

line=`sed "${SGE_TASK_ID}q;d" $1`
in_bam=`echo $line | awk '{ print $1 }'`
out_bam=`echo $line | awk '{ print $2 }'`
rg_tag=`echo $line | awk '{ print $3 }'`

sh add_read_groups.sh $rg_tag $in_bam $out_bam

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
