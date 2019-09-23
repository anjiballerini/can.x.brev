#!/bin/bash

#20190608, ESB

# to make files executable: chmod +x file.sh
# then: ./file.sh


reference="/Volumes/HD/genomes.reference/Aquilegia/V3/sequences/Aquilegia_coerulea.main_genome.scaffolds.fasta"

workingdir="/Volumes/HD/projects/can.brev/align.parents"

datadir="/Volumes/HD/projects/can.brev/parent.demultiplex"


# first need to merge the split raw data
#cd $datadir  

#ls | grep CTGAAGCT | grep R1 | xargs cat > can.merge.R1.fastq.gz
#ls | grep CTGAAGCT | grep R2 | xargs cat > can.merge.R2.fastq.gz
#ls | grep TAATGCGC | grep R1 | xargs cat > brev.merge.R1.fastq.gz
#ls | grep TAATGCGC | grep R2 | xargs cat > brev.merge.R2.fastq.gz

# wondering if i should remove the unmerged data files for space reasons?

#wait


# move to the directory where alignment files will be written to
cd $workingdir

# align canadensis

bwa mem -t 22 -M $reference $datadir/can.merge.R1.fastq.gz $datadir/can.merge.R2.fastq.gz > can.sam
samtools view -b -u -S -t $reference can.sam | samtools sort -m 5G -o can.sorted.bam

#rm can.sam
samtools index can.sorted.bam

# align brevistyla

#bwa mem -t 22 -M $reference $datadir/brev.merge.R1.fastq.gz $datadir/brev.merge.R2.fastq.gz > brev.sam
#samtools view -b -u -S -t $reference brev.sam | samtools sort -m 5G -o brev.sorted.bam

#rm brev.sam
#samtools index brev.sorted.bam





