
#!/bin/sh

#2018-05-22
#2018-06-04, editing to remove the -C 50 variable from samtools mpileup, this helps keep SNPs even if there are lots of variants in a read but when the read still has high map quality, this helps for regions where there are many variants and with aligning more distanly related taxa to the Aq reference

#ESB and AP

#script to call variants across species/genera

infodir="/Volumes/HD/projects/genomes.species/V3/info"

aligndir="/Volumes/HD/projects/genomes.species/V3/alignments"

workingdir="/Volumes/HD/projects/genomes.species/V3/mpileup"

reference="/Volumes/HD/genomes.reference/Aquilegia/V3/sequences/Aquilegia_coerulea.main_genome.scaffolds.fasta"

samtools="/Volumes/HD/tools/samtools-1.3"

bcf="/Volumes/HD/tools/bcftools-1.3"

mpiledir="/Volumes/HD/projects/genomes.species/V3/mpileup"

mkdir $workingdir
cd $workingdir

species=($(cat $infodir/species.list))

for (( k = 0 ; k < ${#species[@]} ; k ++ ))
do

echo ${species[$k]}

#$samtools/samtools mpileup \
#-f $reference \
#-r Chr_01:1-1000000
#-A \
#-B \
#-q 20 \
#$aligndir/${species[$k]}.sorted.bam | $bcf/bcftools view -vcg - > var.raw.${species[$k]}.vcf

# q = minimum mapping quality

$samtools/samtools mpileup -q 30 -u -B -v -f $reference $aligndir/${species[$k]}.sorted.bam | $bcf/bcftools call -vm > var.${species[$k]}.vcf


done


