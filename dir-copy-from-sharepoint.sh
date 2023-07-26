#!/usr/bin/env bash
# dir-copy-from-sharepoint.sh - Script to scopy the contents of a directory from Sharepoint to Apocrita
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=1G
#$ -o copy.o
#$ -e copy.e

module load rclone/1.62.2

dir=$1
echo "Starting $drive copy 1" 1>&2
rclone copy sharepoint-qmul:$dir $dir/  --include "*.{doc,docx,xls,xlsx,xlsm,ppt,pptx,html,png}" --ignore-size --ignore-checksum --drive-acknowledge-abuse
echo "Starting $dir check 1" 1>&2
rclone check sharepoint-qmul:$dir $dir/  --include "*.{doc,docx,xls,xlsx,xlsm,ppt,pptx,html,png}" --ignore-size --ignore-checksum --drive-acknowledge-abuse
echo "Starting $dir copy 2" 1>&2
rclone copy sharepoint-qmul:$dir $dir/  --exclude "*.{doc,docx,xls,xlsx,xlsm,ppt,pptx,html,png}" --drive-acknowledge-abuse
echo "Starting $dir check 2" 1>&2
rclone check sharepoint-qmul:$dir $dir/  --exclude "*.{doc,docx,xls,xlsx,xlsm,ppt,pptx,html,png}" --drive-acknowledge-abuse

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
