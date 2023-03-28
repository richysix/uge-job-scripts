# uge-job-scripts

Job submission scripts for use with Univa Grid Engine

## General

### Download files with curl

Runs [curl-file-download.sh](https://github.com/richysix/bioinf-gen/blob/master/curl-file-download.sh) from [richysix/bioinf-gen](https://github.com/richysix/bioinf-gen/blob/master/curl-file-download.sh).

Array job to download files in batch. Expects files in the working directory named `curl.\[0-9\]+`
An individual task downloads the files contained in curl.${SGE_TASK_ID}

### Check md5sums

[check-md5sums.sh](check-md5sums.sh)

Runs md5sum to check integrity of files.
Expects a file named `md5sum.txt` in the working directory.


## Ensembl

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

## GATK

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

## QC

### FASTQC

[fastqc.sh](fastqc.sh)

Script to run FASTQC on all files matching `*.fastq.gz` in the working directory.
Currently uses 12 threads.

_TO DO_  
Add an option to set the number of threads

### MultiQC

[multiqc.sh](multiqc.sh)

Script to run MultiQC. Expects 2 files in the working directory

1. multiqc-input.txt - list of zipped FASTQC files
1. multiqc-samples.txt - Tab-separated file. 2 columns Run and Sample

## RNA-seq

### Index genome with STAR

[star_ref_index.sh](star_ref_index.sh)

Script to index a genome with star.

    star_ref_index.sh -h
    
    star_ref_index.sh [options] REF_URL GTF_URL
    Options:
        -n    Name (grcz11)
        -d    print debugging info
        -v    verbose output
        -h    print help info

The script uses the REF_URL and GTF_URL to download the genome FASTA file and a GTF file of the annotation.
The index is created in a directory set by the `-n` option (default: grcz11)

### Run STAR

We run STAR with a 2-pass strategy. The first pass maps reads and discovers new splice junctions at the same time.
These splice junctions are used in the second pass to improve mapping.

[star1.sh](star1.sh)

This script expects a file named `fastq.tsv` in the working directory.

`fastq.tsv` should have 3 columns

1. Sample name
1. Read 1 files. A comma-separated list of all the read1 fastq files
1. Read 2 files. A comma-separated list of all the read2 fastq files

To run the script supply a line number from the `fastq.tsv` file.  
e.g. `star1.sh 2` will take the sample name and fastq files from the second line of `fastq.tsv` and run STAR using those arguments.

[star1-array.sh](star1-array.sh)

This script runs star1.sh for multiple samples as an array job

e.g.
```
qsub -t1-12 star1-array.sh
```
This will run 12 jobs taking the input parameters from lines 1 to 12 of `fastq.tsv`
The default number of jobs is 1-96

Once this is complete STAR is run again using the splice junction output of the first run.

[star2.sh](star1.sh)

This is the same as star1.sh, but with the added option `--sjdbFileChrStartEnd` and the splice junction file names.

[star2-array.sh](star2-array.sh)

This script runs star2.sh for multiple samples as an array job

e.g.
```
qsub -t1-12 star2-array.sh
```
This will run 12 jobs taking the input parameters from lines 1 to 12 of `fastq.tsv`
The default number of jobs is 1-96

