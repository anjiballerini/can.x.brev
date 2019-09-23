#!/bin/bash

#2019.02.21, ESB
# a script to demultiplex the can x brev parents

datadir="/Volumes/data.2/data/can.brev/Undetermined.reads/Undetermined_from_190130_NS500585_0238_AH2CGJAFXY_L00"

R1="_R1_001.fastq.gz"
R2="_R2_001.fastq.gz" 

outdir="/Volumes/HD/projects/can.brev/parent.demultiplex"

demux="/Volumes/HD/tools/bbmap/demuxbyname.sh"

mkdir $outdir
cd $outdir

for (( k = 1 ; k < 5 ; k ++ ))
do

$demux in=$datadir$k/"Undetermined_S0_L00"$k$R1 in2=$datadir$k/"Undetermined_S0_L00"$k$R2 \
out="L00"$k"_R1_001_%.fastq.gz" out2="L00"$k"_R2_001_%.fastq.gz" \
prefixmode=f substringmode=t int=f \
names=CTGAAGCT+ACGTCCTG,TAATGCGC+GTCAGTAC

done

#names=CTGAAGCT+NNNNNNNN,TAATGCGC+NNNNNNNN
