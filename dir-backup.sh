#!/usr/bin/env bash
# dir-backup.sh - Script to backup a directory to Sharepoint
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=1G
#$ -o copy.o
#$ -e copy.e
#$ -l rocky

source bash_functions.sh

USAGE="dir-backup.sh [options] dir remote"

OPTIONS="Options:
    -b    base_dir
    -r    Rclone version
    -d    print debugging info
    -q    turn verbose output off
    -h    print help info"

# default values
debug=0
verbose=1
RCLONE_VERSION='1.65.2'
BASE_DIR=""
while getopts ":b:r:dhq" opt; do
  case $opt in
    b)  BASE_DIR=$OPTARG ;;
    r)  RCLONE_VERSION=$OPTARG ;;
    d)  debug=1  ;;
    h)  usage "" ;;
    q)  verbose=0 ;;
    \?) usage "Invalid option: -$OPTARG" ;;
    :)  usage "Option -$OPTARG requires an argument!" ;;
  esac
done
shift "$(($OPTIND -1))"

module load rclone/$RCLONE_VERSION

dir=$1
remote=$2
if [[ -z $remote ]]; then
    remote="sharepoint-qmul-buschlab"
fi

if [[ -z $BASE_DIR ]]; then
  remote_dir=$dir
else
  remote_dir="$BASE_DIR/$dir"
fi

if [[ $verbose -eq 1 ]]; then
  VERBOSE="--progress"
else
  VERBOSE=""
fi

if [[ $debug -eq 1 ]]; then
  echo "Dir: $dir
Remote name: $remote
Base Dir: $BASE_DIR
Remote Dir: $remote_dir
Verbose opt: $VERBOSE" 1>&2
fi

echo "Starting $dir backup 1" 1>&2
rclone copy $VERBOSE $dir $remote:$remote_dir/ --include "*.{doc,docx,xls,xlsx,xlsm,ppt,pptx,html,png}" \
--ignore-size --ignore-checksum --drive-acknowledge-abuse --update

echo "Starting $dir backup 2" 1>&2
rclone copy $VERBOSE $dir $remote:$remote_dir/ --exclude "*.{doc,docx,xls,xlsx,xlsm,ppt,pptx,html,png}" \
--drive-acknowledge-abuse --update

module unload rclone/$RCLONE_VERSION

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
