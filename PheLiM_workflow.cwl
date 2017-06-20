

cwlVersion: v1.0
class: Workflow


doc: |
  Workflow to run PheLiM


## INPUTS
inputs:

  off_target_predictions: File
  huesken_table: File
  siRNA_fasta: File
  mRNA_fasta: File
  phenotypes: File
  output: string
  HierClustering_executable: File
  number_of_randomizations: int
  number_of_cores: int


## OUTPUTS
outputs:

  gene_contributions:
    type: File
    outputSource: PheLiM/output_contributions



## STEPS
steps:

  Clustering_siRNA:
    run: cluster/cluster.cwl
    in:
      siRNA_fasta: siRNA_fasta
      HierClustering_executable: HierClustering_executable
    out: [ output_clusters ]

  Predict_OnTarget_Sites:
    run: interactionmatrix/predictions/ontarget/get_BS_on_transcript.cwl
    in:
      mRNA_fasta: 
      siRNA_fasta: 
    out: [ output_sites ]

  Calculate_OnTarget_Scores:
    run: interactionmatrix/predictions/ontarget/
    in:
      huesken_table: husken_table
      binding_sites: Predict_OnTarget_Sites/output_sites
    out: [ output_ontarget_predictions ]

  Predictions_to_Matrix:
    run: interactionmatrix/prediction-to-matrix.cwl
    in:
      off_target_predictions: off_target_predictions
      on_target_predictions: Calculate_OnTarget_Scores/output_on_target_predictions
    out: [ output_matrix ]

  PheLiM:
    run: PheLiM.cwl
    in: 
      siRNA_phenotype_associations: phenotypes
      siRNA_clusters: Clustering_siRNA/output_clusters
      interaction_matrix: Predictions_to_Matrix/output_matrix
      output_file: output
      ex_expressions_filter:
        default:
      number_of_cores:
        default: 1
      number_of_randomizations:
        default: 30
    out: [ output_contributions ]


