#!/bin/bash

# Collect number of reads in the fastq without unzipping
seqtk size Ohio-515-rep2_S11_L001_R1_001.fastq.gz

# OUTPUT: 21014011	3173115661

# Downsize the sample Ensure you use the same random seed -s100 to keep paired reads
seqtk sample -s100 Ohio-515-rep2_S11_L001_R1_001.fastq.gz 100000 > downsample_R1.fastq
seqtk sample -s100 Ohio-515-rep2_S11_L001_R2_001.fastq.gz 100000 > downsample_R2.fastq

