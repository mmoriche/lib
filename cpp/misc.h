#ifndef MISC_H_
#define MISC_H_

#include <iostream>
//#include <fstream>
#include <string>

extern const int baselength;

using namespace std;


void printHeader(string afile,ostream& unit=cout);
void helpdoc(char odir[],string afile, string alabel="");


#endif
