#include "HierClust.h"

HierClust::HierClust(unsigned int s,double** a) {
	size = s;
	adjacency = new double*[size];
	for(int i=0;i<size;i++) {
		adjacency[i] = new double[size];
		for(int j=0;j<size;j++) {
			adjacency[i][j] = a[i][j];
		}
	}
	node = new vector<Node*>;
}

HierClust::~HierClust() {
	for(int i=0;i<size;i++) {
		delete [] adjacency[i];
	}
	delete [] adjacency;
	delete node;
}

void HierClust::setNodeName(vector<string>* m) {
	mirname = m;
}

void HierClust::start_clustering(double lim, string printfile) {
	for(int i=0;i<size;i++) {
		node->push_back(new Node(vector<int>(1,i),-1,-1));
	}
	bool printnowdone = false;
	double max = 0.0;
	double tempmax = 0.0;
	int a = -1;
	int b = -1;
	vector<int> veca;
	vector<int> vecb;
	vector<int> newnode;
	unsigned int sizea;
	unsigned int sizeb;
	while(node->back()->getNodenumber().size()<size) {
		max = -1.0;
		a = -1;
		b = -1;
		for(int i=0;i<node->size();i++) {
			if(node->at(i)->getLevel()<0) { continue; }
			else {
				for(int j=i+1;j<node->size();j++) {
					if(node->at(j)->getLevel()<0) { continue; }
					veca = node->at(i)->getNodenumber();
					vecb = node->at(j)->getNodenumber();
					sizea = veca.size();
					sizeb = vecb.size();
					tempmax = 0.0;
					for(int k=0;k<sizea;k++) {
						for(int l=0;l<sizeb;l++) {
							tempmax += adjacency[veca[k]][vecb[l]];
						}
					}
					tempmax = tempmax/(sizea*sizeb);

					if(tempmax>max) {
						max = tempmax;
						a = i;
						b = j;
					}
				}

			}
		}
		#ifdef DEBUG
			cout << a << " + " << b << " -> " << node->size()-1 << " (" << max << ")" << endl;
		#endif
		veca = node->at(a)->getNodenumber();
		vecb = node->at(b)->getNodenumber();
		veca.insert(veca.end(),vecb.begin(),vecb.end()); 
		node->push_back(new Node(veca,a,b));
		node->at(a)->downgrade(node);
		node->at(b)->downgrade(node);

		if(!printnowdone && lim!=0. && max<=lim) {
			print_now(printfile);
			printnowdone = true;
		}
	}
}

void HierClust::print_now(string filename) {
	vector<int> vec;
	vector<int> newnode;
	int sizevec;
	ofstream outfile(filename.c_str());
	for(int j=0;j<node->size();j++) {
		#ifdef DEBUG
			cout << "node " << j << "\tlivello " << node->at(j)->getLevel() << endl;
		#endif
		if( node->at(j)->getLevel()==0 ) {
			vec = node->at(j)->getNodenumber();
			sizevec = vec.size();
			#ifdef DEBUG
				cout << "Size vec: " << sizevec << endl;
			#endif
			for(int i=0;i<sizevec;i++) {
				outfile << mirname->at(vec[i]);
				if(i!=(sizevec-1)) outfile << "|";
			}
			outfile << endl;
		}
	}
	outfile.close();
}

void HierClust::fetch2Cluster() {
	int root = node->size()-1;
	vector<int> vec;

	ofstream outfile1("cluster_1.txt");
	int child = node->at(root)->getChildA();
	if(child>=0) {
		vec = node->at(child)->getNodenumber();
		for(int i=0;i<vec.size();i++) {
			outfile1 << mirname->at(vec[i]) << endl;
		}
				
	}

	outfile1.close();

	ofstream outfile2("cluster_2.txt");
	child = node->at(root)->getChildB();
	if(child>=0) {
		vec = node->at(child)->getNodenumber();
		for(int i=0;i<vec.size();i++) {
			outfile2 << mirname->at(vec[i]) << endl;
		}
				
	}

	outfile2.close();
}

void HierClust::Graphviz(string filename) {
	int root = node->size()-1;
	ofstream outfile(filename.c_str());
	outfile << "graph {" << endl << "root=" << root << endl;
	for(int i=0;i<=root;i++) {
		if(i<size) {
			outfile << i << " [label=\"" << mirname->at(i) << "\"]" << endl;
		} else {
			outfile << i << " [label=\"\"]" << endl;
		}
	}
	for(int i=0;i<=root;i++) {
		if(node->at(i)->getChildA()>=0) {
			outfile << i << " -- " << node->at(i)->getChildA() << endl
				<< i << " -- " << node->at(i)->getChildB() << endl;
		}
	}
	outfile << "}" <<endl;
	outfile.close();
}

void HierClust::fetchCluster_with(double distance) {
	double max = 0.0;
	vector<int> vec;
	vector<int> newnode;
	unsigned int sizevec;
	string filename;
	stringstream ssfolder;
	stringstream ssnome;
	for(int j=0;j<node->size();j++) {
		vec = node->at(j)->getNodenumber();
		sizevec = vec.size();
		max = 0.0;
		for(int k=0;k<sizevec;k++) {
			for(int l=k+1;l<sizevec;l++) {
				max += adjacency[vec[k]][vec[l]];
			}
		}
		max = 2*max/((sizevec-1)*(sizevec-1));
		if(distance>(max-0.5) && distance<=(max+0.5)) {
			ssfolder.str("");
			ssfolder.clear();
			ssnome.str("");
			ssnome.clear();
			ssfolder << distance;
			ssnome << j;
			filename = ssfolder.str()+"/"+ssnome.str()+".txt";
			ofstream outfile(filename.c_str());
			for(int i=0;i<sizevec;i++) {
				outfile << mirname->at(vec[i]) << endl;
			}
			outfile.close();
		}
	}
}




