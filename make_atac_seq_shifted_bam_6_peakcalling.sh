#!/bin/bash
#
#  Peak calling
#  
#  STEP 7 
#
#  Name   :  make_atac_seq_shifted_bam_7_peakcalling.sh
#
#  Purpose: This routine calls peaks using macs (with and wout bampe option)
#
#  Author:
#            Duygu Ucar, PhD
#
#  Date:     2017 November 15
#
#  Call:     make_atac_seq_shifted_bam_7_peakcalling.sh
#
#  Assumptions:  
#
#            1.  code has been checked out - fastqc has been run - working directory created
#            2.  we are in the same directory as the scripts.
#            3.  trimmomatic has been run
#            4.  bwa has been run
#            5.  shifted_bam has been called to make the sam file correct for ATAC_seq
#            6.  bam files are converted to bed files           
#
#-------------------------------------------------------------------------------------
#!/bin/bash

scriptDIR=$(pwd)
workingDIR=$scriptDIR/working
inputDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa
peakDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/Broad_peaks
peakDIR2=$workingDIR/trimmomatic/adapterTrimmed/bwa/Bampe_peaks

# Clean files from previous runs
rm -r $peakDIR
rm -r $peakDIR2

mkdir $peakDIR
mkdir $peakDIR2

#rm $workingDIR/bedfilelist.txt
$workingDIR/bamfilelist.txt
rm $workingDIR/MACS.qsub

#ls -1 $inputDIR/*bed > $workingDIR/bedfilelist.txt
ls -1 $inputDIR/*sorted.bam > $workingDIR/bamfilelist.txt
FILENUMBER=$(wc -l $workingDIR/bamfilelist.txt | cut -d' ' -f1)

echo \#!/bin/bash > $workingDIR/MACS.qsub
echo \#PBS -l nodes=1:ppn=16 >> $workingDIR/MACS.qsub
echo \#PBS -l walltime=12:00:00 >> $workingDIR/MACS.qsub
echo \#PBS -N peakcall  >> $workingDIR/MACS.qsub
echo \#PBS -t 1-$FILENUMBER >> $workingDIR/MACS.qsub
echo module load python >> $workingDIR/MACS.qsub
echo module load R >> $workingDIR/MACS.qsub
echo module load perl/5.10.1 >> $workingDIR/MACS.qsub
echo module load samtools/0.1.19 >> $workingDIR/MACS.qsub
echo module load bedtools >> $workingDIR/MACS.qsub
echo module load MACS/2.1.0.20151222 >> $workingDIR/MACS.qsub
echo FILE=\$\(head -n \$PBS_ARRAYID $workingDIR/bamfilelist.txt \| tail -1\) >> $workingDIR/MACS.qsub
echo FILENAME=\$\(basename \"\${FILE}\" \| sed \'s/\.bam/_broad_peaks/g\'\)  >> $workingDIR/MACS.qsub
echo FILENAME1=\$\(basename \"\${FILE}\" \| sed \'s/\.bam/_bampe_peaks/g\'\)  >> $workingDIR/MACS.qsub
echo macs2 callpeak -t \$FILE -f BAM --outdir $peakDIR/ -n \$FILENAME  -g 'hs' --nomodel --shift -100 --extsize 200 --broad -B >> $workingDIR/MACS.qsub
echo macs2 callpeak -t \$FILE -f BAMPE --outdir $peakDIR2/ -n \$FILENAME1  -g 'hs' >> $workingDIR/MACS.qsub

qsub -V $workingDIR/MACS.qsub

echo "use qstat -u <username> to check the status of your job" 
echo "done with STEP 7 when qsub is complete"

