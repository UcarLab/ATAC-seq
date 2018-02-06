#!/bin/bash
#
#  Make IGV and Genome Browser files for visualization
#  
#  STEP 8 
#
#  Name   :  make_atac_seq_shifted_bam_8_igvfiles.sh
#
#  Purpose: This routine generates tdf files for IGV and bedgraph files for UCSC GB
#
#  Author:
#            Duygu Ucar, PhD
#
#  Date:     2017 December 15
#
#  Call:     make_atac_seq_shifted_bam_8_igvfiles.sh
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
#
#-------------------------------------------------------------------------------------
#!/bin/bashmake_atac_seq_shifted_bam_8_igvfiles.sh

scriptDIR=$(pwd)
workingDIR=$scriptDIR/working
inputDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa
igvDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/IGV
gbDIR=$workingDIR/trimmomatic/adapterTrimmed/bwa/BedGraph

# Clean files from previous runs
rm -r $igvDIR
rm -r $gbDIR

mkdir $igvDIR
mkdir $gbDIR

#rm $workingDIR/bedfilelist.txt
rm $workingDIR/bamfilelist.txt

#ls -1 $inputDIR/*bed > $workingDIR/bedfilelist.txt
ls -1 $inputDIR/*sorted.bam > $workingDIR/bamfilelist.txt
FILENUMBER=$(wc -l $workingDIR/bamfilelist.txt | cut -d' ' -f1)

echo \#!/bin/bash > $workingDIR/BW.qsub
echo \#PBS -l nodes=1:ppn=16 >> $workingDIR/BW.qsub
echo \#PBS -l walltime=12:00:00 >> $workingDIR/BW.qsub
echo \#PBS -N igv  >> $workingDIR/BW.qsub
echo \#PBS -t 1-$FILENUMBER >> $workingDIR/BW.qsub
echo module load python/2.7.3 >> $workingDIR/BW.qsub
echo module load bedtools/2.17.0 >> $workingDIR/BW.qsub
echo module load samtools/0.1.19 >> $workingDIR/BW.qsub
echo module load java/1.8.0_73 >> $workingDIR/BW.qsub
echo module load kent/default >> $workingDIR/BW.qsub

# Change file names 
echo FILE=\$\(head -n \$PBS_ARRAYID $workingDIR/bamfilelist.txt \| tail -1\) >> $workingDIR/BW.qsub
echo BASENAME=\$\(basename \"\${FILE}\" \| sed \'s/\.bam//g\'\)  >> $workingDIR/BW.qsub
echo FILENAME=\$\(basename \"\${FILE}\" \| sed \'s/\.bam/\.bedGraph/g\'\)  >> $workingDIR/BW.qsub
echo FILENAME2=\$\(basename \"\${FILE}\" \| sed \'s/\.bam/\.tdf/g\'\)  >> $workingDIR/BW.qsub
echo FILENAME3=\$\(basename \"\${FILE}\" \| sed \'s/\.bam/\.bw/g\'\)  >> $workingDIR/BW.qsub

# run programs
echo /home/ducar/Software/HOMER/bin/makeTagDirectory $gbDIR/\$BASENAME \$FILE -genome hg19 -single -fragLength 150 >> $workingDIR/BW.qsub
echo /home/ducar/Software/HOMER/bin/makeUCSCfile $gbDIR/\$BASENAME -fragLength 150 -o $gbDIR/\$FILENAME >> $workingDIR/BW.qsub
echo /home/ducar/Software/HOMER/bin/makeUCSCfile $gbDIR/\$BASENAME -bigWig /home/ducar/Genomes/hg19.chrom_v2.sizes -fragLength 150 -o $gbDIR/\$FILENAME3 >> $workingDIR/BW.qsub
echo gunzip $gbDIR/*.gz >> $workingDIR/BW.qsub 
#echo bedGraphToBigWig $gbDIR/\$FILENAME /home/ducar/Genomes/mm10_v2.chrom.sizes $gbDIR/\$FILENAME3 >> $workingDIR/bW.qsub
echo /home/ducar/Software/IGVTools/igvtools toTDF $gbDIR/\$FILENAME $igvDIR/\$FILENAME2 hg19 >> $workingDIR/BW.qsub

qsub -V $workingDIR/BW.qsub
echo "use qstat -u <username> to check the status of your job" 
echo "done with STEP 8 when qsub is complete"

