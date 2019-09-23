#!/bin/bash

#20190605, ESB

# to make files executable: chmod +x file.sh
# then: ./file.sh


reference="/Volumes/HD/genomes.reference/Aquilegia/V3/sequences/Aquilegia_coerulea.main_genome.scaffolds.fasta"

workingdir="/Volumes/HD/projects/can.brev/align.v3"

datadir="/Volumes/data.2/data/2019.01.novaseq/Project_SCEB_L1_canxbrev"

infodir="/Volumes/HD/projects/can.brev/info"
mkdir $infodir

# move to the directory where alignment files will be written to
cd $workingdir


# outer loop to cycle through plates 1-4

for (( j = 1 ; j < 5 ; j++ ))
do

# make a file of data file names
ls $datadir/plate$j.demultiplex | grep R1 |  awk '{ gsub(/_R1.fastq.gz/, ""); print }' > $infodir/sample.list.$j

#make a file of sample names that will match the order of the data file names
ls $datadir/plate$j.demultiplex | grep R1 |  awk '{ gsub(/_R1.fastq.gz/, ""); print }' | cut -c 1-4 > $infodir/sample.names.$j

samples=($(cat $infodir/sample.list.$j))
samplename=($(cat $infodir/sample.names.$j))

# inner loop to cycle through samples in a plate
	for (( k = 0 ; k < ${#samples[@]} ; k++ ))
	do

	read1="$datadir/plate$j.demultiplex/${samples[$k]}_R1.fastq.gz"
	read2="$datadir/plate$j.demultiplex/${samples[$k]}_R2.fastq.gz"

	bwa mem -t 22 -M $reference $read1 $read2 > ${samplename[$k]}.sam

	samtools view -b -u -S -t $reference ${samplename[$k]}.sam | samtools sort -m 5G -o ${samplename[$k]}.sorted.bam

	rm ${samplename[$k]}.sam

	samtools index ${samplename[$k]}.sorted.bam

	done
	
done


