cwlVersion: v1.0
class: CommandLineTool
baseCommand: [ perl, /home/andrea/MEGA/PheLiM_CWL/PheLiM/cluster/cluster.pl ]

doc: |
  generate clusters of siRNAs by seed


inputs:
 
  ### Mandatory Inputs ###
  siRNA_fasta:
    type: File
    inputBinding:
      position: 1
    doc: |
      siRNA fasta file

  HierClustering_executable:
    type: File
    inputBinding:
      position: 2
    doc: |
      executable generating the clustering

outputs:

  output_clusters:
    type: stdout


stdout: clusters_for_randomization.txt


