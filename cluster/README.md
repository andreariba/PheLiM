## Generate siRNA clusters

####Required input:

 1. fasta file with siRNA sequences


####Usage

Compile the c++ program in the 'program' folder

	cd program
	make clean
	make
	cd ..

run the perl script

	perl cluster.pl sirna.fa program/HierClustering.exe > clusters_for_randomization.txt

####Output

The clustered siRNAs will be in

	clusters_for_randomization.txt


