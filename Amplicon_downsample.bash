#!/bin/bash

# Collect number of reads in the fastq without unzipping
seqtk size Ohio-515-rep2_S11_L001_R1_001.fastq.gz

# OUTPUT: 21014011	3173115661
R1='downsample_R1.fastq'
R2='downsample_R2.fastq'

# Downsize the sample Ensure you use the same random seed -s100 to keep paired reads
seqtk sample -s100 Ohio-515-rep2_S11_L001_R1_001.fastq.gz 100000 > $R1
seqtk sample -s100 Ohio-515-rep2_S11_L001_R2_001.fastq.gz 100000 > $R2

# Merge the paired end reads
bash ~/Bioinformatics/bbmap/bbmerge.sh in=$R1 in2=$R2 \
    reads=-1 out=merged_reads.fastq