#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>
#include <cstring>
#include <string>
#include "HierClust.h"
#include "mirna_score.h"

//#define DEBUG

using namespace std;

int main(int argc,char *argv[]) {
	if(argc!=5) {
		cout << "Usage: " << argv[0] << " -<hamming|seed> <maxdist> <fastafile> <outfile>" << endl;
		exit(-1);
	}

	ifstream inputfile(argv[3]);
	string outfilename = argv[4];
	//ofstream mirnalist("sequence_list.txt");
	//ofstream seedthreescorefile("seedthreescore_matrix.txt");
	if( !inputfile.is_open() ) {
		cout << "Invalid or inexistent file: " << argv[2] << endl;
		exit(-1);
	}
	bool seed = false;
	if( strcmp(argv[1],"-seed")==0 ) {
		seed=true;
	}
	double lim = atof(argv[2]);
	vector<string>* mirname = new vector<string>;
	//vector<string>* mimat = new vector<string>;
	vector<string>* sequence = new vector<string>;
	char linename[5000];
	char linesequence[100];

	while(!inputfile.eof()) {
		int k=0;
		inputfile.getline(linename,1000);
		inputfile.getline(linesequence,100);
		int len = strlen(linename);
		/*if(len>0) {
			for(int i=0;i<len;i++) {
				if(linename[i]==' ') {
					linename[i]='\0';
					if(k==0) k=i+1;
				}
			}
			mirname.push_back(&linename[1]);
			mimat.push_back(&linename[k]);
			sequence.push_back(linesequence);
		}*/
		if(strcmp(linesequence,"")==0) {
			//cout << "Warning: invalid sequence" << endl;
			continue;
		}
		//cout << &linename[1] << "\t" << linesequence << endl;
		mirname->push_back(&linename[1]);
		sequence->push_back(linesequence);
	}

	/*for(int i=0;i<mirname.size();i++) {
		mirnalist << mirname[i] << "\t" << mimat[i] << "\t" << sequence[i] << "\t" << sequence[i].length() << endl;
	}
	mirnalist.close();*/

	//cout << "Sequence names ok" << endl;

	unsigned int size = mirname->size();
	double **seedscore;
	//double **seedthreescore;
	seedscore = new double*[size];
	//seedthreescore = new double*[size];
	for(int i=0;i<size;i++) {
		seedscore[i] = new double[size];
		//seedthreescore[i] = new double[size];
	}
	double score = 0.0;
	for(int i=0;i<size;i++) {
		for(int j=0;j<size;j++) {
			seedscore[i][j]=0.0;
			seedscore[j][i]=0.0;
			//seedthreescore[i][j]=0.0;
		}
	}
	for(int i=0;i<size;i++) {
		seedscore[i][i]=0.0;
		//seedthreescore[i][i]=0.0;
		for(int j=i+1;j<size;j++) {
			//score = miRNAscore::Hamming(sequence->at(i),sequence->at(j));
			if(seed) {
				score = miRNAscore::seedScore(sequence->at(i),sequence->at(j));
			} else {
				score = miRNAscore::Hamming(sequence->at(i),sequence->at(j));
			}
			seedscore[i][j] = score;
			seedscore[j][i] = score;
			//cout << sequence->at(i) << "|" << sequence->at(j) << ": " << score << endl;
			//score += miRNAscore::threeprimeScore(sequence[i],sequence[j]);
			//seedthreescore[i][j] = score;
			//seedthreescore[j][i] = score;
		}
	}
	
	/*
	ofstream seedscorefile("seedscore_matrix.txt");
	for(int i=0;i<size;i++) {
		for(int j=0;j<size;j++) {
			if(j>0) {
				seedscorefile << "\t";
				//seedthreescorefile << "\t";
			}
			seedscorefile << seedscore[i][j];
			//seedthreescorefile << seedthreescore[i][j];
		}
		seedscorefile << endl;
		//seedthreescorefile << endl;
	}
	
	seedscorefile.close();
	//seedthreescorefile.close();*/
	//cout << "Score ok" << endl;

	HierClust hc(size,seedscore);
	hc.setNodeName(mirname);
	hc.start_clustering(lim, outfilename);
	//cout << "Clustering ok" << endl;

	hc.Graphviz("dotfile.gv");
	//cout << "GraphViz ok" << endl;

	/*hc.fetch2Cluster();
	cout << "Two biggest clusters ok" << endl;

	hc.fetchCluster_with(6);
	hc.fetchCluster_with(5);
	hc.fetchCluster_with(4);
	hc.fetchCluster_with(3);
	hc.fetchCluster_with(2);

	cout << "Cluster in file ok" << endl;*/

	for(int i=0;i<size;i++) {
		delete [] seedscore[i];
	}
	delete [] seedscore;

	delete mirname;
	delete sequence;

	return 0;
}
