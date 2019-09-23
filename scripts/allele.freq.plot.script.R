setwd("/Volumes/HD/projects/can.brev/F2.genotype/ancestry")
file.list = list.files(pattern="output.")
data.list = lapply(file.list[1:10], read.table) #only did this for 10 files to start as it takes awhile to read in the data
ind.list=gsub("output.", "", file.list)
ind.list=gsub(".txt", "", ind.list)

setwd("/Volumes/HD/projects/can.brev/F2.genotype/ancestry.read.frequency")
options(scipen = 999)

bin.size = 500000


for (i in 1:length(data.list)){	
	
data.in=data.list[[i]]
by.chrom=split(data.in, data.in$V1)

position = vector()
can.allele.freq = vector()
brev.allele.freq = vector()
chrom = vector()

	for (j in 1:7){
		
		data.temp = by.chrom[[j]][,]
		position.temp = seq(from=1, to=max(by.chrom[[j]]$V2), by=bin.size)
		can.allele.freq.temp <- rep(NA, length(position.temp))
		brev.allele.freq.temp <- rep(NA, length(position.temp))
		chrom.temp <- rep(j, length(position.temp))

		for (cur.bin in 1:length(position.temp)){

			bin.max <- cur.bin * bin.size
			bin.min <- bin.max - bin.size + 1
			cur.data <- data.temp[(data.temp$V2 >= bin.min) & (data.temp$V2 <= bin.max),]
			can.count <- sum(cur.data$V3)
			brev.count <- sum(cur.data$V4)
			can.freq <- can.count / (can.count + brev.count)
			brev.freq <- brev.count / (can.count + brev.count)

			can.allele.freq.temp[cur.bin] <- can.freq
			brev.allele.freq.temp[cur.bin] <- brev.freq

		}

	position = c(position, position.temp)
	can.allele.freq = c(can.allele.freq, can.allele.freq.temp)
	brev.allele.freq = c(brev.allele.freq, brev.allele.freq.temp)
	chrom = c(chrom, chrom.temp)
	
	}
	
df=data.frame(chrom, position, can.allele.freq, brev.allele.freq)
write.table(df, paste(ind.list[i], ".table.txt", sep=""), quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)

	
pdf(paste(ind.list[i], ".pdf", sep=""), 8,12)

par(mfrow=c(7,1))
par(mar=c(4,2,1,1))
par(oma=c(2,2,1,1))

for (k in 1:7){

	plot(df[df$chrom==k,2]+0.5*bin.size, df[df$chrom==k,3], pch=16, col="red", xlim=c(0,max(df[df$chrom==k,2]+bin.size)), ylim=c(0,1), xlab="", ylab="read frequency")
	lines(df[df$chrom==k,2]+0.5*bin.size, df[df$chrom==k,3], col="red")
	points(df[df$chrom==k,2]+0.5*bin.size, df[df$chrom==k,4], pch=16, col="blue")
	lines(df[df$chrom==k,2]+0.5*bin.size, df[df$chrom==k,4], col="blue")
	mtext(paste("position on Chr0",k, sep=""),3,0.5)

	}
par(xpd=TRUE)
legend(500000, -0.25, legend=c("A. canadensis read frequency", "A. brevistyla read frequency"), pch=16, lty=1, col=c("red", "blue"), bty="n")
dev.off()

}


##########################################################################s


plot(df$position+0.5*bin.size, df$can.allele.freq, pch=16, col="red", xlim=c(0,max(by.chrom[[j]]$V2)), ylim=c(0,1), xlab="position on Chr01", ylab="read frequency")
lines(df$position+0.5*bin.size, df$can.allele.freq, col="red")
points(df$position+0.5*bin.size, df$brev.allele.freq, pch=16, col="blue")
lines(df$position+0.5*bin.size, df$brev.allele.freq, col="blue")
par(xpd=TRUE)
legend(500000, 1.2, legend=c("A. canadensis read frequency", "A. brevistyla read frequency"), pch=16, lty=1, col=c("red", "blue"), bty="n")
dev.off()

