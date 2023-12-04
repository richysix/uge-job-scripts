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

### Rclone

[dir-backup.sh](dir-backup.sh)

Uses rclone to backup a directory between Apocrita and Sharepoint using
`rclone copy`.
First argument is the directory
Second is the name of the rclone remote [Default: sharepoint-qmul-buschlab]

`qsub ~/checkouts/uge-job-scripts/dir-backup.sh [dir] [remote]`

[dir-sync.sh](dir-sync.sh)

Uses rclone to sync a directory between Apocrita and Sharepoint.
First argument is the directory
Second is the name of the rclone remote [Default: sharepoint-qmul-buschlab]

`qsub ~/checkouts/uge-job-scripts/dir-sync.sh [dir] [remote]`

[dir-copy-from-sharepoint.sh](dir-copy-from-sharepoint.sh)

Uses rclone to copy the contents of a directory from Sharepoint to Apocrita.
Expects that rclone is configured with the QMUL Sharepoint Documents directory 
named `sharepoint-qmul`

`qsub ~/checkouts/uge-job-scripts/dir-copy-from-sharepoint.sh [dir]`

[dir-copy-from-sharepoint-with-filter.sh](dir-copy-from-sharepoint-with-filter.sh)

Uses rclone to copy files matching a filter string from Sharepoint to Apocrita.
Expects that rclone is configured with the QMUL Sharepoint Documents directory 
named `sharepoint-qmul`

`qsub ~/checkouts/uge-job-scripts/dir-copy-from-sharepoint.sh [dir] [filter_string]`

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
        -r    reference fasta file [default: $SHARED/genomes/GRCz11/GRCz11.fa]
        -d    print debugging info
        -q    quiet output
        -h    print help info

### GATK SplitNCigarReads

[gatk-split_n_cigar_reads.sh](gatk-split_n_cigar_reads.sh)
Runs GATK SplitNCigarReads to deal with RNA-seq reads that span splice junctions.

`gatk-split_n_cigar_reads.sh -h`

    gatk-split_n_cigar_reads.sh [options] INPUT_BAM OUTPUT_BAM
    
    Options:
        -r    reference fasta file [default: /data/SBBS-BuschLab/genomes/GRCz11/GRCz11.fa]
        -d    print debugging info
        -q    turn off verbose output
        -h    print help info
    
[gatk-split_n_cigar_reads-array.sh](gatk-split_n_cigar_reads-array.sh)

Runs gatk-split_n_cigar_reads.sh as an array job.
Expects a file in the working directory called `bams.tsv`.
It should have 3 columns

1. path to input bam file
1. path to output bam file
1. path to genome reference fasta file

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

## SAMTOOLS

### Index

[samtools_index.sh](samtools_index.sh)

`samtools index` can be run with option `-M`, which means all arguments are treated as bam files to index
Alternatively, it expects a single bam file and optionally a name for the index.
The `samtools_index.sh` script can be run both ways as well

e.g.
```
qsub ~/checkouts/uge-job-scripts/samtools_index.sh -M \
$( find ./ -type f -name "Aligned.sortedByCoord.out.bam" | sort -V | tr '\n' ';' | sed -e 's|;| |g' )

qsub ~/checkouts/uge-job-scripts/samtools_index.sh in.bam out.bai
```

### Add Read Groups

[add_read_groups.sh](add_read_groups.sh) runs `samtools addreplacerg`  
It expects 3 arguments

1. Read group tag e.g. '@RG\tID:samplename\tSM:samplename'
1. Input bam filename
1. Output bam filename

[add_read_groups-array.sh](add_read_groups-array.sh) runs `add_read_groups.sh` in batch.  
It expects a filename as the only argument. This should be a file with 3 columns.

1. Input bam filename
1. Output bam filename
1. Read group tag e.g. '@RG\tID:samplename\tSM:samplename'


## GenMap

[GenMap](https://github.com/cpockrandt/genmap) calculates mappability scores for genome sequences

### Index genome

[genemap_index.sh](genemap_index.sh)

This indexes the supplied genome fasta file

[genemap.sh](genemap.sh)

This runs GenMap to calculate mappability given a specific kmer length (-k) and number of mismatches (-e)

e.g. `qsub ~/checkouts/uge-job-scripts/genmap.sh -k 75 -e 2 /data/scratch/bty114/projects/genomes/GRCz11/genmap-grcz11 mappability`


## Bed file tools

### bigWigToBedGraph

[bigWigToBedGraph.sh](bigWigToBedGraph.sh)

The script runs bigWigToBedGraph. It expects 2 arguments, INPUT FILE and OUTPUT FILE

e.g.
```
qsub bigWigToBedGraph.sh wgEncodeCrgMapabilityAlign50mer.bigWig wgEncodeCrgMapabilityAlign50mer.bedGraph
```

