#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=1G
#$ -o get_ensembl_gene_annotation.o
#$ -e get_ensembl_gene_annotation.e

module purge
module load Ensembl/VERSION

perl $HOME/checkouts/bio-misc/get_ensembl_gene_annotation.pl \
--species SPECIES > OUTPUT_FILE
