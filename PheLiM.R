#!/usr/bin/R

suppressPackageStartupMessages(library(PheLiM))

suppressPackageStartupMessages(library(argparse))

# create parser
parser <- ArgumentParser()

parser$add_argument("phenotypes", nargs=1, type="character", help="siRNA-phenotype associations")
parser$add_argument("clusters", nargs=1, type="character", help="siRNAs clustered by seed.")
parser$add_argument("interactions", nargs=1, type="character", help="interaction matrix")
parser$add_argument("output", nargs=1, type="character", help="output file name")

parser$add_argument("-e", "--expressions", type="character", default="noexpression", help="list of genes/transcripts for the regression [default %(default)s]")

parser$add_argument("-t", "--n_cores", type="integer", default=1, help="number of cores [default %(default)s]")
parser$add_argument("-f", "--n_fit", type="integer", default=30, help="number of randomizations [default %(default)s]")

#parse arguments
args <- parser$parse_args()


#run PheLiM
phenotypefile=args$phenotypes

sirnaclustersfile=args$clusters

expressionfile=args$expressions

interactionfile=args$interactions

outputfile=args$output

ncores=args$n_cores

nfit=args$n_fit


cat("\n\n\nParsed arguments:\n")
cat(paste("[Phenotypes] : ", phenotypefile, "\n", sep="")) 
cat(paste("[Clusters] : ", sirnaclustersfile, "\n", sep=""))
cat(paste("[Interactions] : ", interactionfile, "\n", sep=""))
cat(paste("[Expression filter] : ", expressionfile, "\n", sep=""))
cat(paste("[N. of cores] : ", ncores, "\n", sep=""))
cat(paste("[N. of randomizations] : ", nfit, "\n", sep=""))
cat(paste("[Output file] : ", outputfile , "\n", sep=""))


cat("\n\n\nPheLiM parameters:\n")

outputPheLiM <- PheLiM( phenotypes=phenotypefile, clusters=sirnaclustersfile, intmatrix=interactionfile, expressed=expressionfile, ncores=ncores, nfit=nfit )

write.table(outputPheLiM$contributions, outputfile, sep="\t", row.names=FALSE)


