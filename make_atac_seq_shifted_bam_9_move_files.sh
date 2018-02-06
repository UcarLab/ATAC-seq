#!/bin/bash
#
#  Make IGV and Genome Browser files for visualization
#  
#  STEP 9
#
#  Purpose: Organize files/folders
#
#  Author:
#            Duygu Ucar, PhD
#
#  Date:     2017 December 15
#
#
#  Assumptions:  
#
#            1.  code has been checked out - fastqc has been run - working directory created
#            2.  we are in the same directory as the scripts.
#            3.  trimmomatic has been run
#            4.  bwa has been run
#            5.  shifted_bam has been called to make the sam file correct for ATAC_seq
#            6.  bam files are converted to bed files           
#            7.  peak calling is completed
#            8.  bedgraph files are generated
#-------------------------------------------------------------------------------------
dataDIR=$1 #ARGV, contains folder to move files to
mkdir -p $dataDIR

scriptDIR=$(pwd)
workingDIR=$scriptDIR/working
bamDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa
gbDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/BedGraph
bampeDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/Bampe_peaks
broadDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/Broad_peaks
igvDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/IGV

mkdir $dataDIR/bamfiles
mkdir $dataDIR/bedfiles
mkdir $dataDIR/bedGraph
mkdir $dataDIR/IGV
mkdir $dataDIR/peaks
mkdir $dataDIR/peaks/bampe
mkdir $dataDIR/peaks/broad
mkdir $dataDIR/metrics
mkdir $dataDIR/insertSize

mv $bamDIR/*bam $dataDIR/bamfiles
mv $bamDIR/*bai $dataDIR/bamfiles
mv $bamDIR/*bed $dataDIR/bedfiles
mv $bamDIR/*insertSize* $dataDIR/insertSize
mv $bamDIR/*metrics.txt $dataDIR/metrics
mv $gbDIR/*bedGraph $dataDIR/bedGraph
mv $gbDIR/*bw $dataDIR/bedGraph
mv $igvDIR/*tdf $dataDIR/IGV
mv $bampeDIR/* $dataDIR/peaks/bampe
mv $broadDIR/* $dataDIR/peaks/broad


