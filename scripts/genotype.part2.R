# script to convert a table of canadensis allele frequencies into genotypes in format A/H/B for mapping in Rqtl

setwd("~/Dropbox/Hodges.lab/Rqtl/can.x.brev.2/allele.freq.tables")

file.list.ancestry = list.files(pattern=".can.freq")
ind.list = gsub(".can.freq.txt", "", file.list.ancestry)

data.list = lapply(file.list.ancestry, read.table)

col <- as.character(c("chrom", "pos", ind.list))

#start with first file in data frame and convert to a table
temp.table <- data.frame(data.list[1])

# add frequency data from each additional file to the same table
for (i in 2:length(data.list)) {
		V3 <- data.list[[i]]$V3
		temp.table <- cbind(temp.table, V3)
}

colnames(temp.table) <- col

write.table(temp.table, file="temp.table.out.txt", col.names=T, row.names=F, sep="\t", quote=F)

#temp.table <- read.table(file="temp.table.out.txt", header=F, stringsAsFactors = F)

# swap frequency counts for A/H/B, A = hom can, B = hom brev, H = heterozygous

temp.table[ , 3:ncol(temp.table)][temp.table[ , 3:ncol(temp.table)] > 0.85] = "A"

temp.table[ , 3:ncol(temp.table)][(temp.table[ , 3:ncol(temp.table)] >= 0.65)&(temp.table[ , 3:ncol(temp.table)] <= 0.85)] = "-"

temp.table[ , 3:ncol(temp.table)][(temp.table[ , 3:ncol(temp.table)] >= 0.35)&(temp.table[ , 3:ncol(temp.table)] <= 0.65)] = "H"

temp.table[ , 3:ncol(temp.table)][(temp.table[ , 3:ncol(temp.table)] < 0.35)&(temp.table[ , 3:ncol(temp.table)] > 0.15)] = "-"

temp.table[ , 3:ncol(temp.table)][(temp.table[ , 3:ncol(temp.table)] <= 0.15)&(temp.table[ , 3:ncol(temp.table)] >= 0)] = "B"

write.table(temp.table, file="genotype.table.out.txt", col.names=T, row.names=F, sep="\t", quote=F)





