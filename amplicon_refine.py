#!/bin/python3

import pysam
import os
import argparse

def main():
    parser = argparse.ArgumentParser(description="Filter BAM alignments by reference positions.")
    parser.add_argument("-s", "--start", type=int, required=True, help="Reference start position")
    parser.add_argument("-e", "--end", type=int, required=True, help="Reference end position")
    parser.add_argument("-i", "--input_bam", required=True, help="Input BAM file", default=f'{os.getcwd()}/extract_mermap.bam')
    parser.add_argument("-o", "--output_bam", required=True, help="Output BAM file")

    args = parser.parse_args()

    start = args.start
    end = args.end
    input_bam = args.input_bam
    output_bam = args.output_bam

    # Open the input BAM file for reading
    input_bamfile = pysam.AlignmentFile(input_bam, "rb")

    # Create a new BAM file for writing the filtered alignments
    output_bamfile = pysam.AlignmentFile(output_bam, "wb", template=input_bamfile)

    # Iterate through the alignments and filter based on reference positions
    for alignment in input_bamfile:
        if alignment.reference_start < start or alignment.reference_end > end:
            continue
        # If the alignment passes the filter, write it to the output BAM file
        output_bamfile.write(alignment)

    # Close the BAM files
    input_bamfile.close()
    output_bamfile.close()

if __name__ == "__main__":
    main()