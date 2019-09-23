#!/bin/bash

#2014-06-03, code for calling SNPs off merged F2 bam files
#2015-05-21

mkdir /Volumes/HD/organize/ecalxsib/genotype.v3/genotype
cd /Volumes/HD/organize/ecalxsib/genotype.v3/genotype

#REGION = (can specify a region)
F2BAM="/Volumes/HD/organize/ecalxsib/align.v3/F2.merge/merged.F2.bam"
SIBBAM="/Volumes/HD/organize/ecalxsib/align.v3/sib/SHEB007B.sorted.bam"
reference="/Volumes/HD/assemblies/genome.20150313/sequences/Aquilegia_coerulea.main_genome.scaffolds.fasta"

bcf="/Volumes/HD/organize/bioinformatics/samtools-0.1.19/bcftools"
samtools="/Volumes/HD/bioinformatics/samtools-0.1.19/samtools"

# on a specific region
#samtools mpileup -r $REGION -q 60 -u -C 50 -B -f $reference $F2BAM | bcftools view -vcg - > var.raw1.F2.vcf 

# or for whole genome
$samtools mpileup -q 60 -u -C 50 -B -f $reference $F2BAM | $bcf/bcftools view -vcg - > var.raw.F2.vcf 

# use vcfutils.pl to filter variable positions in the F2s, use the awk command to select lines without indels that have a high quality score (99 in column 10) and that are heterozygous (0/1 or 1/2, but not 1/1 in column 10) 

#vcfutils.pl varFilter -Q 30 -d 20 -D 150 -w 5 var.raw.F2.vcf | awk '  ( ( $8 !~ /^INDEL/ ) && ( $10 ~ /\:99/ ) && ( $10 !~ /1\/1/) || ( $1 ~ /^#/ ) { print $0 } ' > var.filter.F2.hets.vcf 

# could potentially just print $1 and $2 for the list of heterozygous SNP positions in the F2
# may need to adjust the -d and -D variables

$bcf/vcfutils.pl varFilter -Q 30 -d 20 -D 150 -w 5 var.raw.F2.vcf | awk '  ( ( $8 !~ /^INDEL/ ) && ( $10 ~ /\:99/ ) && ( $10 !~ /1\/1/)) { print $1 "\t" $2 } ' > F2.het.pos.txt

# going to run mpileup on the sibirica parent, but only at the sites variable in F2, drop the -v from bcftools view to print non-variable sites
# the following didn't generate what i thought it would - only printed variable sites, maybe that extra dash is a problem??

$samtools mpileup -q 60 -u -C 50 -I -B -f $reference -l F2.het.pos.txt $SIBBAM | $bcf/bcftools view -cg - > sib.genotypes.vcf 

$bcf/vcfutils.pl varFilter -Q 30 -d 20 -D 150 -w 5 sib.genotypes.vcf | awk '  ( ( $8 !~ /^INDEL/ ) && ( $10 ~ /\:99/ ) && ( $10 !~ /0\/1/) && ( $10 !~ /1\/2/)) { print $1 "\:" $2 "\t" $4 "\t" $5 } ' > sib.hom.pos.txt

# try to output the homozygous allele in a file that is pos allele (chr_0:266	A) for the sibirica parent, this would be equivalent to the alleles.sib.txt file - maybe print another column, either 4 or 5
# maybe see what sib.genotypes.vcf looks like first

# again not sure why extra dash is in here...

$samtools mpileup -q 60 -u -C 50 -I -B -f $reference -l F2.het.pos.txt $F2BAM $SIBBAM | $bcf/bcftools view -cg - > F2.sib.genotypes.vcf 


$bcf/vcfutils.pl varFilter -Q 30 -d 20 -D 150 -w 5 F2.sib.genotypes.vcf | awk '  ( ( $8 !~ /^INDEL/ ) && ( $11 ~ /\:99/ ) && ( $11 !~ /0\/1/) && ( $10 !~ /1\/2/)) { print $1 "\:" $2 "\t" $4 "\t" $5 "\t" $11 } ' > var.genotypes.txt

# get a print out in the following format pos \t siballele \t ecalallele

awk ' { if ( $4 ~ /0\/0/ ) print $1 "\t" $2 "\t" $3; else print $1 "\t" $3 "\t" $2; } ' var.genotypes.txt > pos.sibal.ecalal.txt

awk < pos.sibal.ecalal.txt ' { print $1 } ' | awk ' { gsub (/\:/, "\t"); print } ' > snp.list.txt