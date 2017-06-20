cwlVersion: v1.0
class: CommandLineTool
baseCommand: [perl, /home/andrea/MEGA/PheLiM_CWL/PheLiM/interactionmatrix/predictions/ontarget/get_BS_on_transcript.pl]

doc: |
  predict on-target sites for siRNAs


inputs:
 
  ### Mandatory Inputs ###
  mRNA_fasta:
    type: File
    inputBinding:
      position: 1
    doc: |
      file with mRNA sequences

  siRNA_fasta:
    type: File
    inputBinding:
      position: 2
    doc: |
      file with siRNA sequences


outputs:

  output_sites:
    type: File
    outputBinding:
      glob: outontargetsites.tab


