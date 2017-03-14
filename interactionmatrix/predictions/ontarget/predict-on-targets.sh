#!/bin/bash

set -e 

echo "### ON-TARGET PREDICTIONS ###"
if [ "$#" -ne "2" ]; then
	echo "One or more input files are missing.\nUsage: bash predict-on-targets.sh <siRNA fasta file (21nt)> <transcript fasta file>\n"
	exit -1
else
	perl get_BS_on_transcript.pl $2 $1
	Rscript predict_ontargetscore.R outontargetsites.tab
	sed -i  's/\"//g' ontarget_predictions.tab
	rm outontargetsites.tab tempfold.txt sequence.fa sequence.txt
fi
echo "Output: ontarget_predictions.tab"
echo "### ON-TARGET PREDICTIONS DONE ###"


