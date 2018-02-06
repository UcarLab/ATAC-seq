#!/bin/bash
#  A script to summarize QC metrics
#
#  Purpose:  Summarize QC for a bunch of files
#             
#  Author:
#           Duygu Ucar, PhD
#
#  Date:    2017 December
#
#-------------------------------------------------------------------------------------
workingDIR=$1 #ARGV, contains folder with metric files and etc
rm $workingDIR/filelist.txt
rm $workingDIR/metric.qsub

metricDIR=$workingDIR/metrics
peakDIR=$workingDIR/peaks

ls -1 $metricDIR/*metrics.txt > $workingDIR/filelist.txt
FILENUMBER=$(wc -l $workingDIR/filelist.txt | cut -d' ' -f1)

echo $FILENUMBER

echo \#!/bin/bash >> $workingDIR/metric.qsub
echo \#PBS -l nodes=1:ppn=16 >> $workingDIR/metric.qsub
echo \#PBS -l walltime=48:00:00 >> $workingDIR/metric.qsub
echo \#PBS -N bwa >> $workingDIR/metric.qsub
echo \#PBS -t 1-$FILENUMBER%100 >> $workingDIR/metric.qsub
echo module load python >> $workingDIR/metric.qsub
echo module load R >> $workingDIR/metric.qsub
echo module load perl/5.10.1 >> $workingDIR/metric.qsub
echo module load samtools/0.1.19 >> $workingDIR/metric.qsub
echo module load bedtools >> $workingDIR/metric.qsub
echo FILE=\$\(head -n \$PBS_ARRAYID $workingDIR/filelist.txt \| tail -1\) >> $workingDIR/metric.qsub
echo PEAKFILE1=\$\(basename "\${FILE}"\| sed \'s/metrics\.txt/shifted_sorted_bampe_peaks_peaks\.narrowPeak/g\'\) >> $workingDIR/metric.qsub
echo PEAKFILE2=\$\(basename "\${FILE}"\| sed \'s/metrics\.txt/shifted_sorted_broad_peaks_peaks\.broadPeak/g\'\) >> $workingDIR/metric.qsub
echo OUTFILE=\$\(basename "\${FILE}"\| sed \'s/metrics\.txt/summary\.txt/g\'\) >> $workingDIR/metric.qsub
echo more $FILE | head -8 | tail -2 > $metricDIR/$OUTFILE >> $workingDIR/metric.qsub

######
qsub -V $workingDIR/metric.qsub

echo "made the call to $workingDIR/bwa.qsub -- wait until that job is complete before going to STEP 3"
echo "use qstat -u <username> to check the status of your job" 
echo "done with STEP 3 when qsub is complete go to STEP 4 make_atac_seq_shifted_bam_4_bwa_bam_shift"

