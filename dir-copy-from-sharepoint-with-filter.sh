#!/usr/bin/env bash
# dir-copy-from-sharepoint-with-filter.sh - Script to copy files matching a filter string from Sharepoint to Apocrita
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=1G
#$ -o copy.o
#$ -e copy.e

module load rclone/1.62.2

dir=$1
filter_string=$2
echo "Starting $drive copy 1" 1>&2
rclone copy sharepoint-qmul:$dir $dir/  --filter "+ ${filter_string}" --filter "+ */" --filter "- *" --drive-acknowledge-abuse

module unload rclone/1.62.2

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
