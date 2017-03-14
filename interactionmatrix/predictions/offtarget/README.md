
#off-target prediction

####Requirements:

1. RNAplfold from ViennaRNA package
2. Perl libraries required by TargetScan7: Statistics::Lite, Bio::TreeIO (from BioPerl)

####Input:

1. siRNA fasta file
2. UTR fasta file
3. ORF fasta file

####Usage:

	bash predict-off-targets.sh <siRNA fasta file (21nt)> <transcript UTR fasta file> <transcript ORF fasta file>


####Output file

	offtarget_predictions.tab


