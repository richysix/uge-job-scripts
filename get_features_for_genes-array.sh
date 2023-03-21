#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=100M
#$ -t 1-10

USAGE="get_features_for_genes.sh [options] input_file"

OPTIONS="Options:
    -e    Ensembl version [default: 106]
    -s    Species [default: danio_rerio]
    -o    Name of output file [default: gene-features.tsv]
    -d    print debugging info
    -q    quiet output
    -h    print help info"

# default values
debug=0
verbose=1

while getopts "e:s:o:dhq" opt; do
  case $opt in
    e)
      ENSEMBL=$OPTARG
      ;;
    s)
      SPECIES=$OPTARG
      ;;
    o)
      OUTPUT_FILE=$OPTARG
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
    q)
      verbose=0
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

# set defaults
if [[ -z $ENSEMBL ]]; then ENSEMBL=106; fi
if [[ -z $SPECIES ]]; then SPECIES='danio_rerio'; fi
if [[ -z $OUTPUT_FILE ]]; then OUTPUT_FILE='gene-features.tsv'; fi
OUTPUT_FILE="${OUTPUT_FILE}.${SGE_TASK_ID}"

FOFN=$1
if [[ ! -e $FOFN ]];then 
  echo "$FOFN does not exist!" >&2 
  exit 2
fi

INPUT_FILE=$(sed -n "${SGE_TASK_ID}p" $FOFN)
if [[ ! -e $INPUT_FILE ]];then 
  echo "$INPUT_FILE does not exist!" >&2 
  exit 2
fi


if [[ $verbose -gt 0 ]]; then
  echo "Ensembl version = $ENSEMBL
Species = $SPECIES
Output file = $OUTPUT_FILE
Input file = $INPUT_FILE"
fi

module purge
module load Ensembl/$ENSEMBL

perl $HOME/checkouts/analysis-paralogs/get_features_for_genes.pl --species $SPECIES \
--output_file $OUTPUT_FILE $INPUT_FILE
