#ifndef HIERCLUST_H
#define HIERCLUST_H

#include <iostream>
#include <cstring>
#include <sstream>
#include <string>
#include <vector>
#include <fstream>

#include "Node.h"

using std::string;
using std::vector;
using std::cout;
using std::flush;
using std::endl;
using std::ofstream;
using std::stringstream;

class HierClust {
public:
  HierClust(unsigned int,double**);
  ~HierClust();
  void start_clustering(double lim, string prinffile);
  void setNodeName(vector<string>*);
  void Graphviz(string);
  void fetchCluster_with(double);
  void fetch2Cluster();
  void print_now(string filename);
private:
  double **adjacency;
  unsigned int size;
  vector<Node*> *node;
  vector<string>* mirname;
};

#endif
