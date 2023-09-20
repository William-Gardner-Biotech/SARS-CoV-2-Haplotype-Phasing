#!/bin/bash

#This script maps merges the reads first instead of in1 and in2 option on bbmap

# Input File names
#in1='data/Ohio-515-rep2_S11_L001_R1_001.fastq.gz'
#in2='data/Ohio-515-rep2_S11_L001_R2_001.fastq.gz'
ref_genome="$HOME/Bioinformatics/Viral_Genomes/SARS-COV-2-NC_045512.2.fasta"  # Use $HOME to specify the home directory
seqID_folder=$(basename "$in1" .fastq.gz | sed 's/R1/RN/')/

# Region of Interest
ROIstart=4520
ROIend=4748

# Varnames
bbmap="$HOME/Bioinformatics/bbmap"  # Use $HOME to specify the home directory
processed_folder="amp_$ROIstart-$ROIend/"
merged_reads='data/merged_reads.fasta'
mer_mapped_reads='data/mer_mapped_reads.sam'
mer_mapped_reads_bam='data/mer_mapped_reads.bam'
extracted='data/extract_mermap.bam'
sorted_mm='data/sorted_mermap.bam'
pre_phase="data/amp_${ROIstart}-${ROIend}_final_filter.bam"

# Test params 1 21200-21444 yields 1 million reads
#

# Downsample Numbers
seed=100
size=100000

echo 'RUNNING'

# Collect number of reads in the fastq without unzipping
#seqtk size $in1

# OUTPUT: 21014011 3173115661
R1='data/downsample_R1.fastq'
R2='data/downsample_R2.fastq'

# Downsize the sample
# Ensure you use the same random seed -s100 to keep paired reads
#seqtk sample "-s$seed" $in1 100000 > "$R1"
#seqtk sample "-s$seed" $in2 100000 > "$R2"

# Drop the unmapped reads 
# -b makes bam file, -o flags output file
# BAM to SAM
echo 'Merged checkpoints'

#bbmerge.sh in1=$R1 in2=$R2 out=$merged_reads
#Testing on whole dataset
bbmerge.sh in1=$R1 in2=$R2 out=$merged_reads 

echo 'CHECK1'

bbmap.sh in=$merged_reads out=$mer_mapped_reads ref=$ref_genome maxindel=200 threads=8

echo 'CHECK2'

samtools view -b -o $mer_mapped_reads_bam $mer_mapped_reads

echo 'CHECK3'

samtools sort $mer_mapped_reads_bam -o $sorted_mm

echo 'CHECK4'

samtools index $sorted_mm

echo 'CHECK5'

samtools view -b $sorted_mm "NC_045512.2 Severe acute respiratory syndrome coronavirus 2 isolate Wuhan-Hu-1, complete genome":$ROIstart-$ROIend > $extracted

echo 'CHECK6'

samtools index $extracted
echo "COMPLETED AMPLICON EXTRACTION. FILE SAVED AS $extracted"

python3 bin/amplicon_refine.py -s $ROIstart -e $ROIend -i $extracted -o $pre_phase

echo "FINISHED FINAL FILTERING STEP BEFORE PHASING, FILE SAVE AS $pre_phase"

echo 'CHECK7'

# Variant calling using bcftools mpileup

echo 'CHECK8'

# Index the BCF file for efficient access


echo 'CHECK9'

# Phase variants using BCFtools


echo 'CHECK10'

# Index the phased BCF file
