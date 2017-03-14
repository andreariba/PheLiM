#ifndef MIRNASCORE
#define MIRNASCORE
#include <cstring>
#include <string>
using namespace std;

class miRNAscore {
public:
	static double Hamming(string,string);
	static double seedScore(string,string);
	static double threeprimeScore(string,string);
};

#endif
