#### Datasets

Public siRNA screens, you can use to test for your pipeline.
Files are tab-delimited tables, in the following format:

|   ID    |           sequence            | phenotype |
|---------|-------------------------------|-----------|
| siRNA-1 | AATACTGATACGCATCTTCTGAAAAAAAA |    0.02   |
| siRNA-2 | TTCAGGTCCACGTAGACGCAGAAAAAAAA |   -1.38   |
| siRNA-3 | TACAAGGCCATGCTCATCCGTAAAAAAAA |   -4.22   |
|   ...   |              ...              |     ...   |

Generate siRNA fasta file
```
	awk '{print ">"$1"\n"substr($2,1,21);}' table.tab
```
Generate siRNA-phenotype file
```
	awk '{print $1"\t"$3;}' table.tab
```




