#!/bin/bash

#This script maps merges the reads first instead of in1 and in2 option on bbmap

# Input File names
in1='Ohio-515-rep2_S11_L001_R1_001.fastq.gz'
in2='Ohio-515-rep2_S11_L001_R2_001.fastq.gz'
ref_genome="$HOME/Bioinformatics/Viral_Genomes/SARS-COV-2-NC_045512.2.fasta"  # Use $HOME to specify the home directory

# Varnames
bbmap="$HOME/Bioinformatics/bbmap"  # Use $HOME to specify the home directory
merged_reads='merged_reads.fasta'
mer_mapped_reads='mer_mapped_reads.sam'
mer_mapped_reads_bam='mer_mapped_reads.bam'
extracted='extract_mermap.bam'
sorted_mm='sorted_mermap.bam'

# Downsample Numbers
seed=100
size=100000

# Collect number of reads in the fastq without unzipping
seqtk size Ohio-515-rep2_S11_L001_R1_001.fastq.gz

# OUTPUT: 21014011 3173115661
R1='downsample_R1.fastq'
R2='downsample_R2.fastq'

# Downsize the sample
# Ensure you use the same random seed -s100 to keep paired reads
seqtk sample "-s$seed" $in1 100000 > "$R1"
seqtk sample "-s$seed" $in2 100000 > "$R2"

# Drop the unmapped reads 
# -b makes bam file, -o flags output file
# BAM to SAM
ECHO 'Merged checkpoints'

bbmerge.sh in1=$R1 in2=$R2 out=$merged_reads

ECHO 'CHECK1'

bbmap.sh in=$merged_reads out=$mer_mapped_reads ref=$ref_genome maxindel=200

ECHO 'CHECK2'

samtools view -b -o $mer_mapped_reads_bam $mer_mapped_reads

ECHO 'CHECK3'

samtools sort $mer_mapped_reads_bam -o $sorted_mm

samtools index $sorted_mm

samtools view -b $sorted_mm "NC_045512.2 Severe acute respiratory syndrome coronavirus 2 isolate Wuhan-Hu-1, complete genome":5000-5500 > $extracted

ECHO "COMPLETED AMPLICON EXTRACTION. FILE SAVED AS $extracted"