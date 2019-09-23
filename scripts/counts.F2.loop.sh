#!/bin/bash
#2019.06.14

reference="/Volumes/HD/genomes.reference/Aquilegia/V3/sequences/Aquilegia_coerulea.main_genome.scaffolds.fasta"

snplist="/Volumes/HD/projects/can.brev/F2.genotype/ID.alleles/snp.list.txt"

countscript="/Volumes/HD/projects/can.brev/scripts/count.alleles.pl"

bamdir="/Volumes/HD/projects/can.brev/align.v3"

# make a new directory to store our genotype counts in a move to that directory
mkdir /Volumes/HD/projects/can.brev/F2.genotype/counts
cd /Volumes/HD/projects/can.brev/F2.genotype/counts

#create a list of all of the F2 .bam samples in the F2.alignments folder, 
# use grep -v to drop files with bai from our list
# use a combination of awk and gsub to drop "sorted.bam" from our list and replace it with nothing ("")
ls $bamdir | grep -v bai | awk '{ gsub(/.sorted.bam/, "") ; print $0 }' > F2.list


#define a list of variables that will be known as "samples" using our F2.list file
samples=($(cat F2.list))


# make a for loop that will cycle through the list of F2 samples one at a time and genotype each sample at our SNP.list positions
for (( k = 0 ; k < ${#samples[@]} ; k++ ))
do

samtools mpileup -Q 30 -q 60 -B -f $reference -l $snplist $bamdir/${samples[$k]}.sorted.bam | perl $countscript | awk ' { print $1":"$2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 } ' | sort -k 1,1 > ${samples[$k]}.counts

done