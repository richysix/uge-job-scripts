# uge-job-scripts

Job submission scripts for use with Univa Grid Engine

### Get gene annotation from Ensembl

[get_ensembl_gene_annotation.sh](get_ensembl_gene_annotation.sh)

This runs `get_ensembl_gene_annotation.pl` in the directory in which the `qsub` command is executed. There are 2 options to the `get_ensembl_gene_annotation.pl` script which need to be set. To do this, make a copy of this job script and change the words SPECIES and OUTPUT_FILE e.g.

    gitdir=$HOME/checkouts/uge-job-scripts
    sed -e 's|SPECIES|homo_sapiens|;
    s|OUTPUT_FILE||' $gitdir/get_ensembl_gene_annotation.sh > get_ensembl_gene_annotation.sh

Run the job with qsub

    qsub get_ensembl_gene_annotation.sh
