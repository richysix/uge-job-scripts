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

### Get gene features

[get_features_for_genes.sh](get_features_for_genes.sh)

This runs [get_features_for_genes.pl](https://github.com/richysix/analysis-paralogs/blob/main/get_features_for_genes.pl) in the directory in which the `qsub` command is executed. Run `get_features_for_genes.sh -h` to see options for setting the Ensembl version, species and output file name.

[get_features_for_genes-array.sh](get_features_for_genes-array.sh)

This runs [get_features_for_genes.pl](https://github.com/richysix/analysis-paralogs/blob/main/get_features_for_genes.pl) as a job array in the directory in which the `qsub` command is executed. Run `get_features_for_genes-array.sh -h` to see options for setting the Ensembl version, species and output file name. The array task id is added to the output filename. The default number of array tasks is 10. This can be overridden by adding the `-t` option directly to the `qsub` command.

### Run GATK ASEReadCounter

[gatk-ase.sh](gatk-ase.sh)

Runs GATK ASEReadCounter.

`gatk-ase.sh -h`

    gatk-ase.sh [options] INPUT_FILE VCF_FILES
    Options:
        -o    output file name [default: ase-counts.tsv]
        -r    reference fasta file [default: /data/SBBS-BuschLab/genomes/GRCz11/GRCz11.fa]
        -d    print debugging info
        -q    quiet output
        -h    print help info

