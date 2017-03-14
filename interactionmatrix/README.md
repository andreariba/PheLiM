## Generate interaction matrix from predictions (e.g. TargetScan)

####Calculate target predictions

 1. off-targets: run predictions/offtarget/predict-off-targets.sh script
 2. on-targets: run predictions/ontarget/predict-on-targets.sh script 

#### Required inputs

Once you have the two files for off- and on-target predictions.
They should be in the following format:

| gene | siRNA | score |
|------|-------|-------|
|geneA | siRNAA|scoreAA|
|geneB | siRNAA|scoreBA|
|...   |  ...  | ...   |

cat the two files in a unique prediction file

	cat offtarget_predictions.tab ontarget_predictions.tab > prediction_file.tab

####Usage

run the bash script

	bash prediction-to-matrix.sh prediction_file.tab

####Output

The interaction matrix will be in

	output_pivoted.tab


