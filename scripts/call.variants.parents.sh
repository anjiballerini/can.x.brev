#!/bin/bash

#2019-06-14, ESB
# this is a script to identify variant sites in the A. canadensis x A. brevistyla parents
# the eventual snp.list.txt should have sites where can and brev are homozygous for alternate alleles

mkdir /Volumes/HD/projects/can.brev/F2.genotype 

mkdir /Volumes/HD/projects/can.brev/F2.genotype/ID.alleles

cd /Volumes/HD/projects/can.brev/F2.genotype/ID.alleles

reference="/Volumes/HD/genomes.reference/Aquilegia/V3/sequences/Aquilegia_coerulea.main_genome.scaffolds.fasta"

canbam="/Volumes/HD/projects/can.brev/align.parents/can.sorted.bam"
brevbam="/Volumes/HD/projects/can.brev/align.parents/brev.sorted.bam"

# generate mpileups for variant sites for each parent

#samtools mpileup -r Chr_01:1-2000000 -q 30 -B -u -v -f $reference $canbam | bcftools call -vm -f GQ > var.reg.can.vcf
#samtools mpileup -r Chr_01:1-2000000 -q 30 -B -u -v -f $reference $brevbam | bcftools call -vm -f GQ > var.reg.brev.vcf
samtools mpileup -q 30 -B -u -v -f $reference $canbam | bcftools call -vm -f GQ > var.can.vcf
samtools mpileup -q 30 -B -u -v -f $reference $brevbam | bcftools call -vm -f GQ > var.brev.vcf

# filter out SNPs within 3bp of indel, indels, hets

#bcftools filter -g3 var.reg.can.vcf | awk ' ($8 !~ /INDEL/) {print $0} ' | bcftools query -i 'QUAL>30 && DP>18 && DP<70 && GT="1/1" && GQ>99' -f '%CHROM\t%POS\n' > can.reg.hom.pos
#bcftools filter -g3 var.reg.brev.vcf | awk ' ($8 !~ /INDEL/) {print $0} ' | bcftools query -i 'QUAL>30 && DP>18 && DP<60 && GT="1/1" && GQ>99' -f '%CHROM\t%POS\n' > brev.reg.hom.pos

bcftools filter -g3 var.can.vcf | awk ' ($8 !~ /INDEL/) {print $0} ' | bcftools query -i 'QUAL>30 && DP>18 && DP<70 && GT="1/1" && GQ>99' -f '%CHROM\t%POS\n' > can.hom.pos
bcftools filter -g3 var.brev.vcf | awk ' ($8 !~ /INDEL/) {print $0} ' | bcftools query -i 'QUAL>30 && DP>16 && DP<60 && GT="1/1" && GQ>99' -f '%CHROM\t%POS\n' > brev.hom.pos

# need to find things homozygous for different alleles

#get unique sites for homozygous in each to generate a snp.list

#cat can.reg.hom.pos brev.reg.hom.pos | sort | uniq > snp.list.reg
cat can.hom.pos brev.hom.pos | sort | uniq > snp.list.temp

# call variants and genotypes for both the two parents at the list of sites that can be used to determine ancestry

#samtools mpileup -l snp.list.reg -q 30 -u -B -f $reference $canbam $brevbam | bcftools call -vm -f GQ | awk ' ($8 !~ /INDEL/) {print $0} ' | bcftools query -f'%CHROM\:%POS\t%REF\t%ALT[\t%GT]\n' > can.brev.genotypes.reg

samtools mpileup -l snp.list.temp -q 30 -u -B -f $reference $canbam $brevbam | bcftools call -vm -f GQ | awk ' ($8 !~ /INDEL/) {print $0} ' | bcftools query -f'%CHROM\:%POS\t%REF\t%ALT[\t%GT]\n' > can.brev.genotypes

# need to edit script below
#awk ' { if ( $4 ~ /0\/0/ && $5 ~ /1\/1/ ) print $1 "\t" $2 "\t" $3; else if ( $4 ~ /1\/1/ && $5 ~ /0\/0/ ) print $1 "\t" $3 "\t" $2; } ' can.brev.genotypes.reg > pos.canal.breval.reg.txt
awk ' { if ( $4 ~ /0\/0/ && $5 ~ /1\/1/ ) print $1 "\t" $2 "\t" $3; else if ( $4 ~ /1\/1/ && $5 ~ /0\/0/ ) print $1 "\t" $3 "\t" $2; } ' can.brev.genotypes > pos.canal.breval.txt

awk ' { print $1 } ' pos.canal.breval.txt | awk ' { gsub (/\:/, "\t"); print } ' > snp.list.txt
