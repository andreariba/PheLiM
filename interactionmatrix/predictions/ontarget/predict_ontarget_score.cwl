cwlVersion: v1.0
class: CommandLineTool
baseCommand: [ Rscript, /home/andrea/MEGA/PheLiM_CWL/PheLiM/interactionmatrix/predictions/ontarget/predict_ontargetscore.R ]

doc: |
  calculate score for predicted sites


inputs:
 
  ### Mandatory Inputs ###
  huesken_table:
    type: File
    inputBinding:
      position: 1
    doc: |
      Huesken downregulation scores

  binding_sites:
    type: File
    inputBinding:
      position: 2
    doc: |
      predicted binding sites from previous Perl script (get_BS_on_transcript.cwl)


outputs:

  output_ontarget_predictions:
    type: File
    outputBinding:
      glob: ontarget_predictions.tab


