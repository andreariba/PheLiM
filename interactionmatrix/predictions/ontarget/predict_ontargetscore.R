rm(list=ls())

suppressPackageStartupMessages(library(MASS))
suppressPackageStartupMessages(library(argparse))

parser <- ArgumentParser()

parser$add_argument("huesken", nargs=1, type="character", help="Huesken siRNA downregulations")
parser$add_argument("sites", nargs=1, type="character", help="siRNA fasta file")

#parse arguments
args <- parser$parse_args()

tovector <- function(sequence,fold,duplex,acc8=0.0,acc16=0.0) { #
	#selectedpos <- c(1,2,3,4,7,9,10,12,13,14,18,19)
	#selectedpos <- c(1,2,3,4,5,6,7,10,11,13,14,16,17,18,19,20,21)
	selectedpos <- c(1,2,7,10,14,18,19,20,21)
	vec <- c()
	if(nchar(as.character(sequence))<21) {
		print("Not enough!")
	}
	countAU <- 0
	seqlength <- 21
	for(k in 1:seqlength) {
		#print(substring(sequence,i,i))
		if(k %in% selectedpos) {
			switch(substring(as.character(sequence),k,k),
				A={vec <- c(vec,1,0,0,0)
					countAU=countAU+1
				},
				T={vec <- c(vec,0,1,0,0)
					countAU=countAU+1
				},
				U={vec <- c(vec,0,1,0,0)
					countAU=countAU+1
				},
				C={vec <- c(vec,0,0,1,0)},
				G={vec <- c(vec,0,0,0,1)},
				stop("ERROR!")
			)
		}
	}
	ratioAU <- countAU*1.0/seqlength
	#vec <- c(vec, fold, duplex, 1)
	vec <- c(vec, ratioAU, fold/10, (-duplex+40)/20, acc16, 1)
	return(vec)
}

dfall <- read.table(args$huesken)
set <- sample.int(nrow(dfall), nrow(dfall)/9, replace = FALSE)
dftest <- dfall[set,]
dftrain <- dfall[! 1:nrow(dfall) %in% set,]

corTT <- c()
modelstock <- c()

b <- 0.7

for(i in 1:200) {
	matrix <- c()

	all <- 1:nrow(dftrain)
	trainingset <- sample.int(nrow(dftrain), nrow(dftrain)*2/3, replace = FALSE)
	testset <- all [! all %in% trainingset]

	foldchange <- dftrain[,2]-b

	for( i in trainingset ) {
		seq <- dftrain[i,1]
		#print(seq)
		#print(tovector(seq))
		matrix <- rbind(matrix,tovector(seq, dftrain[i,3],dftrain[i,4],dftrain[i,5],dftrain[i,6]) )
	}

	matrix <- cbind(matrix)

	model <- (ginv(t(matrix) %*% matrix) %*% t(matrix)) %*% foldchange[trainingset]
	modelstock <- rbind(modelstock, t(model))

	autotestscore <- c()
	for(i in testset ) {
		#print(tovector(datitestdongen$V1[i]) %*% model)
		autotestscore <- rbind(autotestscore, c( tovector(dftrain[i,1],dftrain[i,3],dftrain[i,4],dftrain[i,5],dftrain[i,6]) %*% model , foldchange[i]) )
	}

	corTT <- rbind(corTT, c(cor(autotestscore)[1,2]))
	#corTT <- rbind(corTT, c(cor(autotestscore)[1,2], 0))
}

model <- colMeans(modelstock)

dfNov <- read.table(args$sites)
scoreNov <- c()
for(i in 1:nrow(dfNov)) {
	scoreNov <- c(scoreNov, tovector(dfNov[i,3],dfNov[i,4],dfNov[i,5],dfNov[i,6],dfNov[i,7]) %*% model) #,dftest[i,5],dftest[i,6]
}

dfNov <- cbind(dfNov,9.1*(scoreNov+b))
write.table(dfNov[,c(2,1,8)], "ontarget_predictions.tab", sep="\t", row.names=F, col.names=F, quote=FALSE)

