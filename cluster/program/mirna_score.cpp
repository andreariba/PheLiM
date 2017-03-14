#include "mirna_score.h"

double miRNAscore::Hamming(string s1, string s2) {
	double score = 0.0;
	int len = ( s1.length()>s2.length() ? s2.length() : s1.length() );
	for(int i=0;i<len;i++) {
		if(s1[i]==s2[i]) score++;
	}
	return score;
}

double miRNAscore::seedScore(string s1, string s2) {
	double score = 0.0;
	int len = ( s1.length()>s2.length() ? s2.length() : s1.length() );
	if(len<9) {
		return -1;
	}
	for(int i=2;i<=9;i++) {
		if(s1[i-1]==s2[i-1]) score++;
	}
	return score;
}

double miRNAscore::threeprimeScore(string s1, string s2) {
	double score = 0;
	int len = ( s1.length()>s2.length() ? s2.length() : s1.length() );
	if(len<16) {
		return -1;
	}
	for(int i=13;i<=16;i++) {
		if(s1[i-1]==s2[i-1]) score+=0.5;
	}
	if(len>=19) {
		for(int i=18;i<=19;i++) {
			if(s1[i-1]==s2[i-1]) score+=0.5;
		}
	}
	return score;
}
