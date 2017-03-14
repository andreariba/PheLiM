#ifndef NODE_H
#define NODE_H

#include <iostream>
#include <vector>
#include <fstream>

using std::vector;
using std::cout;
using std::endl;
using std::ofstream;

class Node {
public:
	Node(vector<int> v,int a, int b) {
		level = 0;
		nodenumber = v;
		childa = a;
		childb = b;
	}
	int getLevel() {return level;}
	void setLevel(int i) {level=i;}
	vector<int> getNodenumber() {return nodenumber;}
	int getChildA() {return childa;}
	int getChildB() {return childb;}
	void downgrade(vector<Node*> *nodes) {
		level--;
		if(childa>=0) nodes->at(childa)->downgrade(nodes);
		if(childb>=0) nodes->at(childb)->downgrade(nodes);
	}
private:
	int level;
	int childa;
	int childb;
	vector<int> nodenumber;
};

#endif
