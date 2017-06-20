cwlVersion: v1.0
class: CommandLineTool
baseCommand: /home/andrea/MEGA/PheLiM_CWL/PheLiM/interactionmatrix/prediction-to-matrix.py

doc: |
  convert the tables of preditions into a matrix


inputs:
 
  ### Mandatory Inputs ###
  off_target_predictions:
    type: File
    inputBinding:
      position: 1
    doc: |
      file with off-target predictions

  on_target_predictions:
    type: File
    inputBinding:
      position: 2
    doc: |
      file with on-target predictions


outputs:

  output_matrix:
    type: File
    outputBinding:
      glob: output_pivoted.tab


