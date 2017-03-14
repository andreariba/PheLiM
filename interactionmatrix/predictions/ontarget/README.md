
#on-target prediction

####Requirement:

1. RNAfold from ViennaRNA package
2. RNAduplex from ViennaRNA package

####Input:

1. mRNA fasta file
2. siRNA fasta file

####Usage:

	bash predict-on-targets.sh <siRNA fasta file (21nt)> <transcript fasta file>

With actual settings it generates consistent on-target score for TargetScan7.

####Output file

	ontarget_predictions.tab


