#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <filesystem> // compile with -std=c++17
#include "misc.h"

namespace fs = std::filesystem;
using namespace std;

void printHeader(string afile, ostream& unit) {
// assumes header is started by /* and finished by */ at BOF
//  ----------------------------------
//  |/*    not this                  |
//  |This will be printed            |
//  |And this                        |
//  |And this                        |
//  |*/     not this                 |
//  |not this                        |
//  |/*    not this                  |
//  |                                |
//  |Neither this                    |
//  |                                |
//  |*/     not this                 |
//  ----------------------------------
string aline; 
char twochars[3];
twochars[2]='\0';

bool isheader=false;

ifstream f;

bool flag=fs::is_regular_file(afile); 

if (not flag) {
   cout << endl << "Source file does not exist. I can not read the header" << endl;
   cout << afile  << endl << endl;
   return;
};

f.open(afile);

if (f.is_open()) {
   for (int i=0;i<80;i++) { unit << "-";}; unit << endl << "<<< maybe this helps... >>>" << endl;
   while (!f.eof()) {
   
      getline(f,aline);

      if (not isheader) {
         strncpy(twochars,&aline[0],2);
         if (strncmp(twochars,"/*",2)==0){isheader=true;};
      } else {
         strncpy(twochars,&aline[0],2);
         if (strncmp(twochars,"*/",2)==0){
            for (int i=0;i<80;i++) { unit << "-";}; unit << endl;
            break;
         };
      };

      if (isheader){ unit << aline << endl;};
   
   }
}
f.close();

}


// write help from header in the output                                                                           
void helpdoc(char odir[],string afile, string alabel){

fs::path README=odir;                                                                                             
//README /= "post";
//bool flag=fs::is_directory(README);                                                                                    
//if ( not flag) {
//   cout <<  "OUTPUT DIRECTORY DOES NOT EXIST, PLEASE CREATE IT" << endl;                                          
//   cout << endl << endl <<  "mkdir -p " << README << endl << endl;                                                
//   exit(EXIT_FAILURE);                                                                                            
//};
README += alabel;
README += ".README";                                                                                        
ofstream f;
f.open(README);
f << endl << "Source file: " << endl;
f << afile << endl;
printHeader(afile,f);                                                                                          
f.close();                                                                                                        

}
 
