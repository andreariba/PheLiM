cwlVersion: v1.0
class: CommandLineTool
baseCommand: [ Rscript, /home/andrea/MEGA/PheLiM_CWL/PheLiM/PheLiM.R ]

doc: |
  run PheLiM core


inputs:
 
  ### Mandatory Inputs ###
  siRNA_phenotype_associations:
    type: File
    inputBinding:
      position: 1
    doc: |
      siRNA associated to the measured phenotype.

  siRNA_clusters:
    type: File
    inputBinding:
      position: 2
    doc: |
      clusters of siRNAs.

  interaction_matrix:
    type: File
    inputBinding:
      position: 3
    doc: |
      file containing the interaction between siRNAs and genes/transcripts.

  output_file:
    type: string
    inputBinding:
      position: 4
    doc: |
      file with estimated gene contributions.


  ### Optional Inputs ###
  ex_expressions_filter:
    type:
      - type: record
        name: file
        fields:
          file:
            type: File
            inputBinding:
              position: 0
              prefix: --expressions
              separate: true
      - type: record
        name: nofile
        fields:
          nofile:
            type: string
            inputBinding:
              position: 0
              prefix: --expressions
              separate: true
      - "null"
    doc: |
      list of transcripts to use in the regression
      default: noexpression

  number_of_cores:
    type: int
    inputBinding:
      position: 0
      prefix: --n_cores
      separate: true
    doc: |
      number of cores (to use carefully! Memory usage grows fast!)
      default: 1

  number_of_randomizations:
    type: int
    inputBinding:
      position: 0
      prefix: --n_fit
      separate: true
    doc: |
      number of randomizations
      default: 30

 
outputs:
  output_contributions:
    type: File
    outputBinding:
      glob: $(inputs.output_file)



