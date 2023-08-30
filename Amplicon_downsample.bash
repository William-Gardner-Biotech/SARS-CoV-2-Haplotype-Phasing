#!/bin/bash

# Input File names
in1='Ohio-515-rep2_S11_L001_R1_001.fastq.gz'
in2='Ohio-515-rep2_S11_L001_R2_001.fastq.gz'
ref_genome="$HOME/Bioinformatics/Viral_Genomes/SARS-COV-2-NC_045512.2.fasta"  # Use $HOME to specify the home directory

# Varnames
bbmap="$HOME/Bioinformatics/bbmap"  # Use $HOME to specify the home directory
merged_reads='merged_reads.fasta'
mapped_reads='mapped_reads.sam'

# Collect number of reads in the fastq without unzipping
# seqtk size Ohio-515-rep2_S11_L001_R1_001.fastq.gz

# OUTPUT: 21014011 3173115661
R1='downsample_R1.fastq'
R2='downsample_R2.fastq'

# Downsize the sample
# Ensure you use the same random seed -s100 to keep paired reads
seqtk sample -s100 "$in1" 100000 > "$R1"
seqtk sample -s100 "$in2" 100000 > "$R2"

# Merge the paired end reads
# bbmerge.sh in=$R1 in2=$R2 reads=-1 out=$merged_reads

# Map the merged reads to the reference genome
bbmap.sh in1=$R1 in2=$R2 ref=$ref_genome out=$mapped_reads

# Drop the unmapped reads 
# -b makes bam file, -o flags output file
# BAM to SAM
samtools view -b -o mapped_reads.bam $mapped_reads
ECHO 'check1'
#samtools index mapped_reads.bam
ECHO 'check2'
samtools view -b -o filtered_reads.bam -f 0x100 -F 0x4 mapped_reads.bam
ECHO 'check3'
samtools index filtered_reads.bam
ECHO 'check4'

samtools view -b -o extracted_amplicons.bam filtered_reads.bam ref:20000-21000

# Extracting amplicons

#samtools index $mapped_reads

#samtools view -b -o extracted_amplicons.bam -T $ref_genome $mapped_reads ref:21652-21980
