#!/bin/bash

UNSORTALLELES="/Volumes/HD/projects/can.brev/F2.genotype/ID.alleles/pos.canal.breval.txt"

# make a new directory to store our ancestry files and move into that directory
mkdir /Volumes/HD/projects/can.brev/F2.genotype/ancestry
cd /Volumes/HD/projects/can.brev/F2.genotype/ancestry

sort -k 1,1 $UNSORTALLELES > pos.canal.breval.sorted.txt

SORTALLELES="/Volumes/HD/projects/can.brev/F2.genotype/ancestry/pos.canal.breval.sorted.txt"
COUNTSDIR="/Volumes/HD/projects/can.brev/F2.genotype/counts"
F2list="/Volumes/HD/projects/can.brev/F2.genotype/counts/F2.list"

#define a list of variables that will be known as "samples" from our F2 list
samples=($(cat $F2list))

# make a for loop that will cycle through the list of F2 samples one at a time and genotype each sample
for (( k = 0 ; k < ${#samples[@]} ; k++ ))
do

join $SORTALLELES $COUNTSDIR/${samples[$k]}.counts > joined.${samples[$k]}.txt

awk ' 
{ if ( $2 ~ "A" && $3 ~ "T" ) print $1 "\t" $4 "\t" $5; 
else if ( $2 ~ "A" && $3 ~ "C" ) print $1 "\t" $4 "\t" $6;
else if ( $2 ~ "A" && $3 ~ "G" ) print $1 "\t" $4 "\t" $7;
else if ( $2 ~ "T" && $3 ~ "A" ) print $1 "\t" $5 "\t" $4;
else if ( $2 ~ "T" && $3 ~ "C" ) print $1 "\t" $5 "\t" $6;
else if ( $2 ~ "T" && $3 ~ "G" ) print $1 "\t" $5 "\t" $7;
else if ( $2 ~ "C" && $3 ~ "A" ) print $1 "\t" $6 "\t" $4;
else if ( $2 ~ "C" && $3 ~ "T" ) print $1 "\t" $6 "\t" $5;
else if ( $2 ~ "C" && $3 ~ "G" ) print $1 "\t" $6 "\t" $7;
else if ( $2 ~ "G" && $3 ~ "A" ) print $1 "\t" $7 "\t" $4;
else if ( $2 ~ "G" && $3 ~ "T" ) print $1 "\t" $7 "\t" $5;
else if ( $2 ~ "G" && $3 ~ "C" ) print $1 "\t" $7 "\t" $6;
} ' joined.${samples[$k]}.txt | awk ' BEGIN { FS = ":" } ; { gsub (/super_/, "" ) ; print $1 "\t" $2 } ' | sort -k 1,1 -k 2,2n > output.${samples[$k]}.txt

rm joined.${samples[$k]}.txt

done