/*
 * Copyright (C) Mohsen Zohrevandi, 2017
 *               Rida Bazzi 2019
 * Do not share this file with anyone


Jonathan Steddom Anand Krishna Mishra

 
 */
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include "lexer.h"
#include <vector>
#include <string>
#include <any>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <sstream>
#include <unordered_set>
#include <map>
#include <utility>
using namespace std;

// Lexer Ojbect
LexicalAnalyzer lexer;

// Vectors for terminals and non-terminals
vector<string> terminals;
vector<string> nonTerminals;
vector<string> all;
vector<string> nonTerminalsFinal;
vector<string> RHS;
vector<string> RHSinP;
vector<string> LHS;

//vector of vectors & task 2 vectors
vector<vector<string>> RHS2_0;
vector<string> reachable;
vector<string> producable;
vector<string> generable;
vector<string> generableNonTerminals;
vector<int> non;

int ruleCount = 0;

void syntax_error()
{
    cout << "SYNTAX ERROR !!!\n";
    exit(0);
}

Token expect(TokenType expected)
{
    Token t = lexer.GetToken();
    if (t.token_type != expected)
    {
        cout << "expect syntax";
        syntax_error();

    }
    return t;
}
void parseID_List(){
  // IDLIST = ID IDLIST | ID
  int ys = 0;
  // Parse ID 
  Token t = lexer.peek(1);
  RHSinP.push_back(t.lexeme);

    
  if (t.token_type == ID){
    int verify = 0;
    for (int i = 0; i < terminals.size(); i++){
      if (t.lexeme == terminals[i])
	verify++;
    }
    for (int i = 0; i < nonTerminals.size(); i++){
      if (t.lexeme == nonTerminals[i])
	verify++;
    }
    
    if (verify == 0){
      terminals.push_back(t.lexeme);
      all.push_back(t.lexeme);
    }
    expect(ID);
    parseID_List();
  }
  else {
    
    if (t.token_type == STAR && RHSinP.size() == 1){
      RHSinP.clear();
      RHSinP.push_back("#");
      ys = 1;
    }
    ostringstream oss;
    for (int i = 0; i < RHSinP.size(); i++){
      oss << " ";
      oss << RHSinP[i];
    }
    string result = oss.str();
    if (ys == 0){
      RHSinP.pop_back();
    }
    RHS.push_back(result);
    RHS2_0.push_back(RHSinP);
    RHSinP.clear();
    ruleCount++;
    return;
  }
}

void parseRHS(){
  // RIGHTHANDSIDE = IDLIST | EPSILON

  // Parse IDLIST
  Token t = lexer.peek(1);
  if (t.token_type != HASH){
    parseID_List();
  }
  
  // Parse HASH
  else {
    expect(HASH);
  }
}

void parseRule(){
  // RULE = ID ARROW RIGHTHANDSIDE STAR

  // Parse ID
  Token t = lexer.peek(1);
  if (t.token_type == ID){
    LHS.push_back(t.lexeme);
    int verify = 0;
    for (int i = 0; i < nonTerminals.size(); i++){
      if (t.lexeme == nonTerminals[i])
	verify++;
    }
    for (int i = 0; i < terminals.size(); i++){
      if(t.lexeme == terminals[i]){
	terminals.erase(terminals.begin()+i);
	}
	
    }
    
    if (verify == 0){
     
      nonTerminals.push_back(t.lexeme);
      all.push_back(t.lexeme);
    }
    expect(ID);
  }
  else {
    // cout << "error 1\n";
    syntax_error();
  }

  // Parse ARROW
  t = lexer.peek(1);
  if (t.token_type == ARROW){
    expect(ARROW);
  }
  else {
    // cout << "error 2\n";
    syntax_error();
  }
  
  // Parse RIGHTHANDSIDE
  parseRHS();
  ruleCount++;
  // Parse Star
  t = lexer.peek(1);
  if (t.token_type == STAR){
    expect(STAR);
  }
  else{
    // cout << "error 3\n";
    syntax_error();
  }
}

void parseRuleList(){
  // RULELIST = RULE RULELIST | RULE

  // Parse RULE
  parseRule();
  // cout << "error 1.1\n";
  // Parse RULELIST if not at end of file
  Token t = lexer.peek(1);
  if (t.token_type != ID){
    return;
   
  }
  else {
     parseRuleList();
  }
}

void parseGrammar(){
  // GRAMMAR = RULELIST HASH

  // Parse RULELIST
  parseRuleList();

  // Parse Hash
  Token t = lexer.peek(1);
  if (t.token_type == HASH){
    expect(HASH);
    expect(END_OF_FILE);
  }
  else {
    cout << "error 4\n";
    syntax_error();
  }
  
}

// read grammar
void ReadGrammar()
{
  parseGrammar();
  //cout << "0\n";
}

void getNonTerminals(){
  int count = 0;
  for (int i = 0; i < all.size(); i++){
    for (int j = 0; j < nonTerminals.size(); j++){
      if(nonTerminals[j] == all[i]){
	for(int k = 0; k < nonTerminalsFinal.size(); k++){
	  if(nonTerminals[j] == nonTerminalsFinal[k])
	    count++;
	}
	if (count == 0)
	  nonTerminalsFinal.push_back(nonTerminals[j]);
	count = 0;
      }
        
    }
  }
}

// Task 1
void printTerminalsAndNoneTerminals()
{
  
  for (int i = 0; i < terminals.size(); i++){
    cout << terminals[i];
    cout << " ";
  }
 
  getNonTerminals();
  for (int i = 0; i < nonTerminalsFinal.size(); i++){
     cout << nonTerminalsFinal[i];
     cout << " ";
   }
 

  
  //cout << "\n1\n";
}



void isProducing(){
  generable.push_back("#");
  for (int i = 0; i < terminals.size(); i++){
    generable.push_back(terminals[i]);
  }
  for (int i = 0; i < LHS.size(); i++){
    int cnt = 0;
    int skipper = 0;
    for (int j = 0; j < RHS2_0[i].size(); j++){
      cnt = count(generable.begin(), generable.end(), RHS2_0[i][j]);
      if (cnt == 0){
	skipper = 1;
	break;
      }
    }
   if (skipper == 1)
      continue;
   generable.push_back(LHS[i]);
  }
  
  for (int i = 0; i < LHS.size(); i++){
    int cnt = 0;
    int skipper = 0;
    for (int j = 0; j < RHS2_0[i].size(); j++){
      cnt = count(generable.begin(), generable.end(), RHS2_0[i][j]);
      if (cnt == 0){
	skipper = 1;
	break;
      }
    }
    if (skipper == 1)
      continue;
   generable.push_back(LHS[i]);
  }
   
   
   for (int i = 0; i < LHS.size(); i++){
    int cnt = 0;
    int skipper = 0;
    for (int j = 0; j < RHS2_0[i].size(); j++){
      cnt = count(generable.begin(), generable.end(), RHS2_0[i][j]);
      if (cnt == 0){
	non.push_back(i);
	skipper = 1;
	break;
      }
    }
   if (skipper == 1)
      continue;
   generable.push_back(LHS[i]);  
    
  }
}

void allUseless(){
  non.clear();
  for (int i = 0; i < LHS.size(); i++){
    non.push_back(i);
  }
}

void isReachable(){
  int startVar = 0;
  for (int i = 0; i < LHS.size(); i++){
    int cut = 0;
    cut = count(non.begin(), non.end(), i);
    if (cut > 0){
      if (LHS[0] != LHS[i]){
	allUseless();
	return;
      }
    }
    if (LHS[0] == LHS[i] && cut == 0){
      startVar = i;
      break;
    }
  }
  reachable.push_back(LHS[startVar]);
  for (int i = 0; i < RHS2_0[startVar].size(); i++){
    reachable.push_back(RHS2_0[startVar][i]);
  }
  for (int i = 0; i < LHS.size(); i++){
    int nill = 0;
    nill = count(non.begin(), non.end(), i);
    if (nill != 0){
      continue;
    }
    int skipper = 0;
    for (int j = 0; j < RHS2_0[i].size(); j++){
      int reach = count(generable.begin(), generable.end(), RHS2_0[i][j]);
      if (reach == 0){
	non.push_back(i);
	cout  << i ;
	skipper = 1;
	break;
      } 
    }
    if (skipper == 1)
      continue;
    int LHS_chk = count(reachable.begin(), reachable.end(), LHS[i]);
    if (LHS_chk >= 1){
      for (int j = 0; j < RHS2_0[i].size(); j++){
	reachable.push_back(RHS2_0[i][j]);
      }
    }
  }
}

void doTask(){
  isProducing();
  isReachable();
  
}

// Task 2
void RemoveUselessSymbols()
{
  
  doTask();
  for (int i = 0; i < LHS.size(); i++){
    int cnt = count(non.begin(), non.end(), i);
    if (cnt >= 1){
      continue;
    }
    else{
      int find = count(reachable.begin(), reachable.end(), LHS[i]);
      if (find == 0)
	continue;
      cout << LHS[i] << " -> ";
      for (int j = 0; j < RHS2_0[i].size(); j++){
	cout << RHS2_0[i][j];
      }
      cout << "\n";
    }
  }
  
  
}


//vector<string> tFs;
//vector<string> ntFs;
//vector<vector<string>> firstSets; 
vector<pair<string, vector<string>>> FirstSets;
void setUp(){
  for (int i = 0; i < terminals.size(); i++){
    vector<string> nonT;
    nonT.push_back(terminals[i]);
    FirstSets.push_back(make_pair(terminals[i], nonT));
  }
  vector<string> nonT;
    nonT.push_back("#");
    FirstSets.push_back(make_pair("#", nonT));
    for (int i = 0; i < nonTerminalsFinal.size(); i++){
      vector<string> nonT;
      FirstSets.push_back(make_pair(nonTerminalsFinal[i], nonT));
      }
    // cout << "we made it\n";
  
}
int change = 0;
int ep = 0;
void addNonTerminal(string add, string place, int noEp){
  vector<string> tempSet;
  for (int i = 0; i < FirstSets.size(); i++){
     if (FirstSets[i].first == add){
       tempSet = FirstSets[i].second;
       break;
     }
  }
   int hasEpsilon = count(tempSet.begin(), tempSet.end(), "#");
	if (hasEpsilon >= 1){
	  //FirstSets[i].second.push_back(tempSet[j]);
	  ep = 1;
	  //continue;
	}
  if (noEp == 0){
    for (int i = 0; i < tempSet.size(); i++){
      if (tempSet[i] == "#")
	tempSet.erase(tempSet.begin() + i);
      
    }
  }

  /////////////////
  // cout << "To add: " << add << "  At: " << place << "\n";
  /*
  cout << "Temp set: ";
  for (int i = 0; i < tempSet.size(); i++){
    cout << tempSet[i];
  }
  cout << "\n";
  */
  /////////////////
  for (int i = 0; i < FirstSets.size(); i++){
    if (FirstSets[i].first == place){
      // Check if terminal is already in First set
      for (int j = 0; j < tempSet.size(); j++){
	int isIn = count(FirstSets[i].second.begin(), FirstSets[i].second.end(), tempSet[j]);
        int hasEp = count(tempSet.begin(), tempSet.end(), "#");
	if (hasEp >= 1){
	  //FirstSets[i].second.push_back(tempSet[j]);
	  ep = 1;
	  //continue;
	}
	if (isIn == 0){
	  FirstSets[i].second.push_back(tempSet[j]);
	  change = 1;
	  tempSet.clear();
	}
      }
      if (change == 1)
	break;
    }
  }
}

void addTerminal(string add, string place){
  //cout <<"TERMINAL TO ADD: " <<add << "AT THIS PLACE: " << place << "\n";
  for (int i = 0; i < FirstSets.size(); i++){
    if (FirstSets[i].first == place){
      //Check if non terminal is already in First set
      int isIn = count(FirstSets[i].second.begin(), FirstSets[i].second.end(), add);
      if (isIn == 0){
	FirstSets[i].second.push_back(add);
	change = 1;
      }
      break;
    }
  }
}

void addEp(string place){
  for (int i = 0; i < FirstSets.size(); i++){
    if (place == FirstSets[i].first){
      int hasEp = count(FirstSets[i].second.begin(), FirstSets[i].second.end(), "#");
      if (hasEp == 0){
	FirstSets[i].second.push_back("#");
	change = 1;
	break;
      }
    }
  }
}

void findFirstSets(){
  terminals.insert(terminals.begin(), "#");
  setUp();
  bool changed = true;
  while (changed){
      changed = false;
      for (int i = 0; i < LHS.size(); i++){
	// Create a vector to update first sets
	//vector<string> uptade;
	for (int j = 0; j < RHS2_0[i].size(); j++){
	  // Check if a terminal
	  int isTerminal = count(terminals.begin(), terminals.end(), RHS2_0[i][j]);
	  //cout << "\n-----" << j << "--" << RHS2_0[i][j] << " -- " << isTerminal << "----\n";
	  if(isTerminal > 0){
	    // Add terminal, function checks if it is already in there
	    addTerminal(RHS2_0[i][j], LHS[i]);
	    if (change == 1){
	      //cout << change << endl;
	      change = 0;
	      changed = true;
	      break;
	    }
	    break;
	  }
	  //cout << "Left Hand: " << LHS[i] << "   Right HAnd: " << RHS2_0[i][j] << endl;
	  int isNonTerminal = count(nonTerminalsFinal.begin(), nonTerminalsFinal.end(), RHS2_0[i][j]);
	  int noEp = 0;
	  if (j + 1 == RHS2_0[i].size()){
	      noEp = 1;
	    }
	  if (isNonTerminal > 0){
	    addNonTerminal(RHS2_0[i][j], LHS[i], noEp);
	    if (change == 1){
	      change = 0;
	      changed = true;
	      if (ep == 1){
		ep = 0;
		continue;
	      }
	      break;
	    }
	    if (ep == 1){
		ep = 0;
		continue;
	    }
	    break;
	    
	  }
	  
	  
	  /*
	  if (RHS2_0[i][j] == "#"){
	    addEp(LHS[i]);
	    if (change == 1){
	      change = 0;
	      changed = true;
	    }
	    }*/
	  
	}
	if (ep == 1){
	  ep = 0;
	  addEp(LHS[i]);
	  if (change == 1){
	    change = 0;
	    changed = true;
	  }
	  
	}
      }
    }
}

// Task 3
void CalculateFirstSets()
{
  getNonTerminals();
  /*
for (int i = 0; i < LHS.size(); i++){
    cout << LHS[i] << " -> ";
    for (int j = 0; j < RHS[i].size(); j++){
      cout << RHS[i][j];
    }
    cout << "\n";
  }
  */
  

//setUp();
 findFirstSets();
 /*
  for (const auto& pair: FirstSets){
    cout << "First("<< pair.first << ") = { " ;
    for (string element: pair.second){
      cout << element << " , ";
    }
    cout << "}\n";
    
  }
 */
 for (int i = 0; i < FirstSets.size(); i++){
   int isTerm = count(terminals.begin(), terminals.end(), FirstSets[i].first);
   if (isTerm > 0)
     continue;
   cout << "FIRST(" << FirstSets[i].first << ") = { ";
   vector<string> toPrint;
     for (int k = 0; k < terminals.size(); k++){
       int order = count(FirstSets[i].second.begin(), FirstSets[i].second.end(), terminals[k]);
       if (order > 0){
	 toPrint.push_back(terminals[k]);
       }
     }
     for (int j = 0; j < toPrint.size(); j++){
       cout << toPrint[j];
       if (j + 1 != toPrint.size())
	 cout << ", ";
     }
     cout << " }\n";
     toPrint.clear();
 }

  
  //findFirstSets();
  //ComputeFirstSets();
  //OutputFirstSets();
}
vector<pair<string, vector<string>>> FollowSets;
vector<string> TMS = terminals;

void setUpTwoHelper(string place, string add){
  
  vector<string> tempSet;
  for (int i = 0; i < FirstSets.size(); i++){
     if (FirstSets[i].first == add){
       tempSet = FirstSets[i].second;
       break;
     }
  }
  /*
   cout << "\nTEMP SET: ";
  for (int i = 0; i < tempSet.size(); i++){
    cout << tempSet[i];
  }
  */
  for (int i = 0; i < FollowSets.size(); i++){
    if (FollowSets[i].first == place){
      int leave = 0;
      for (int j = 0; j < tempSet.size(); j++){
	int comp = count(FollowSets[i].second.begin(), FollowSets[i].second.end(), tempSet[j]);
	//cout << "\nCOMP:  " << comp << endl;
	if (comp == 0){
	  FollowSets[i].second.push_back(tempSet[j]);
	  // changer = 1;
	  leave = 1;
	}
      }
      if (leave == 1){
	return;
      }
      //FollowSets[i].second = tempSet;
      break;
    }
  }
  
}
int changer = 0;
bool changed = true;
void setUpTwoHelperTwo(string place, string add){
  
  vector<string> tempSet;
  for (int i = 0; i < FollowSets.size(); i++){
     if (FollowSets[i].first == add){
       tempSet = FollowSets[i].second;
       break;
     }
  }
  /*
  cout << "\nTEMP SET: ";
  for (int i = 0; i < tempSet.size(); i++){
    cout << tempSet[i];
  }
  */
  //cout << "\n";
  for (int i = 0; i < FollowSets.size(); i++){
    if (FollowSets[i].first == place){
      //int leave = 0;
      for (int j = 0; j < tempSet.size(); j++){
	int comp = count(FollowSets[i].second.begin(), FollowSets[i].second.end(), tempSet[j]);
	//cout << "COMP : " << comp << endl;
	if (comp == 0){
	  FollowSets[i].second.push_back(tempSet[j]);
	  changer = 1;
	  changed = true;
	  //leave = 1;
	}
      }
      /*
      if (leave == 1){
	return;
      }
      //FollowSets[i].second = tempSet;
      break;
      */
    }
  }
  
}


void setUpTwo(){
  terminals.insert(terminals.begin(), "$");
  
  for (int i = 0; i < terminals.size(); i++){
    if (terminals[i] == "#"){
      terminals.erase(terminals.begin() + i);
    }
  }
  
    for (int i = 0; i < nonTerminalsFinal.size(); i++){
    vector<string> nonT;
    if (i == 0){
      nonT.push_back("$");
    }
    
    FollowSets.push_back(make_pair(nonTerminalsFinal[i], nonT));
    nonT.clear();
  }
  ///////////////////////
    /*   
for (int i = 0; i < FollowSets.size(); i++){
    // cout << "FOLLOW\n";
    cout << "FOLLOW(" << FollowSets[i].first << ") = { ";
     vector<string> toPrint;
     for (int k = 0; k < terminals.size(); k++){
       int order = count(FollowSets[i].second.begin(), FollowSets[i].second.end(), terminals[k]);
       if (order > 0){
	 toPrint.push_back(terminals[k]);
       }
     }
     for (int j = 0; j < toPrint.size(); j++){
       cout << toPrint[j];
       if (j + 1 != toPrint.size())
	 cout << ", ";
     }
     cout << " }\n";
     toPrint.clear();
  }
    */
    ///////////////////////
  //cout << "\n--- WE ARE IN---\n";
  for (int i = 0; i < LHS.size(); i++){
    //cout << "\n--- WE ARE IN 2---\n";
    string firstVar = "";
    for (int j = 0; j < RHS2_0[i].size(); j++){
      //int aT = count(terminals.begin(), terminals.end(), firstVar);
      int goNext = 0;
      
      if(j == 0 ){
	firstVar = RHS2_0[i][j];
	continue;
      }
      
      else {
	//cout << "\n Current RHS: " << RHS2_0[i][j] << endl;
	int isT = count(terminals.begin(), terminals.end(), RHS2_0[i][j]);
	int isTT = count(nonTerminalsFinal.begin(), nonTerminalsFinal.end(), firstVar);
	if (isT == 1 && isTT == 1){
	  // cout << " isT:   First Var:  " << firstVar << " RHS:  " << RHS2_0[i][j] << endl;
	  setUpTwoHelper(firstVar, RHS2_0[i][j]);
	  break;
	}
	int out = 0;
	int isNon = count(nonTerminalsFinal.begin(), nonTerminalsFinal.end(), RHS2_0[i][j]);
	if (isNon == 1){
	  //cout << "isNon:   First Var:  " << firstVar << " RHS:  " << RHS2_0[i][j] << endl;
	  setUpTwoHelper(firstVar, RHS2_0[i][j]);
	  firstVar = RHS2_0[i][j];
	  // cout << "\nNew RHS:  " << firstVar << endl;
	  int out = 1;
	}
	/*
	if (out == 1){
	  out = 0;
	  continue;
	}
	*/
	for (int k = 0; k < FirstSets.size(); k++){
	  //cout << "\n--- WE ARE IN 3---\n";
	  if (FirstSets[k].first == LHS[i]){
	    int isEpsilon = count(FirstSets[k].second.begin(), FirstSets[k].second.end(), "#");
	    if (isEpsilon == 1){
	      goNext = 1;
	    }
	    break;
	  }
	}
	if (goNext == 1){
	  continue;
	}
	else{
	  /*
	  cout << "\nbreak\n";
	  break;;
	  */
	}
      }
    }
  }
  
}
int checkEpsilon(string place){
  for (int i = 0; i < FirstSets.size(); i++){
    if (FirstSets[i].first == place){
      int findIt = 0;
      vector<string> looking = FirstSets[i].second;
      for (int j = 0; j < looking.size(); j++){
	if(looking[j] == "#"){
	  findIt = 1;
	  break;
	}
	
      }
      if (findIt == 1)
	return 1;
      else {
	return 0;
      }
    }
    
  }
  return 0;
}

void terminalAdd(string place, string add){
  for (int i = 0; i < FollowSets.size(); i++){
    if (place == FollowSets[i].first){
      FollowSets[i].second.push_back(add);
      break;
    }
  }
}

void findFollowSets(){
  setUpTwo();
  int ticker = 0;
  while (changed) {
    changed = false;
    for (int i = 0; i < LHS.size(); i++){
      //cout << "Looping\n";
      changer = 0;
      for (int j = 0; j < RHS2_0[i].size(); j++){
	//int bp = 0;
	int isN = count(nonTerminalsFinal.begin(), nonTerminalsFinal.end(), RHS2_0[i][j]);
	//cout << "RHS:   " << RHS2_0[i][j] << "   isN val:  " << isN << endl;
	if (isN == 0){
	  //break;
	  continue;
	}
	changer = 0;
	// j + 1
	if (j + 1  == RHS2_0[i].size()){
	  //cout << "j + 1 success" << endl;
	  //cout << "RHS2_0[i][j]:  " << RHS2_0[i][j] << "   has added LHS[i]: " << LHS[i] << endl;
	  //string place, string add
	  setUpTwoHelperTwo(RHS2_0[i][j], LHS[i]);
	}
	
	for (int k = j + 1; k < RHS2_0[i].size(); k++){
	  //cout << "RHS " <<RHS2_0[i][j] << " RHS + 1:  " << RHS2_0[i][k] << endl;
	  int findIt = checkEpsilon(RHS2_0[i][k]);
	  int at = count(terminals.begin(), terminals.end(), RHS2_0[i][k]);
	  // cout << "findIt:  " << findIt << endl;
	  if (findIt == 1){
	    if (k + 1 == RHS2_0[i].size()){
	      setUpTwoHelperTwo(RHS2_0[i][j], LHS[i]);
	    }
	    else {
	      continue;
	    } 
	  }
	  else if (at == 1){
	    terminalAdd(RHS2_0[i][j], RHS2_0[i][k]);
	    break;
	  }
	  else {
	    break;
	  }
	}
	
      }  
    }
  } 
}

// Task 4
void CalculateFollowSets()
{
  getNonTerminals();
  findFirstSets();
  findFollowSets();
  /*
  for (int i = 0; i < LHS.size(); i++){
    cout << LHS[i] << " -> ";
    for (int j = 0; j < RHS[i].size(); j++){
      cout << RHS[i][j];
    }
    cout << "\n";
  }
  */
  

  
  //cout << "\n---IT IS FINISHED---\n";
  for (int i = 0; i < FollowSets.size(); i++){
    // cout << "FOLLOW\n";
    cout << "FOLLOW(" << FollowSets[i].first << ") = { ";
     vector<string> toPrint;
     for (int k = 0; k < terminals.size(); k++){
       int order = count(FollowSets[i].second.begin(), FollowSets[i].second.end(), terminals[k]);
       if (order > 0){
	 toPrint.push_back(terminals[k]);
       }
     }
     for (int j = 0; j < toPrint.size(); j++){
       cout << toPrint[j];
       if (j + 1 != toPrint.size())
	 cout << ", ";
     }
     cout << " }\n";
     toPrint.clear();
  }
  // cout << "4\n";
}

// Task 5
void CheckIfGrammarHasPredictiveParser()
{
  /*
  terminals.insert(terminals.begin(), "#");
  for (int i = 0; i < terminals.size(); i++){
    cout << terminals[i];
  }
  
  vector<string> temp;
  for (int i = 0; i < RHS2_0[i].size(); i++){
    temp = RHS2_0[i];
    break;
  }
  cout << "temp v: " ;
  for (int i = 0; i < temp.size(); i++){
    cout << temp[i];
  }
  */

  bool HUS = true;
  if (HUS){
    cout << "NO" << endl;
  }
  else {
    cout << "YES" << endl;
  }




  
  /*
  if (non.size() == 0)
    cout << "YES";
  else{
    cout << "NO";
  }
  */
  // cout << "5\n";
}
    
int main (int argc, char* argv[])
{
    int task;

    if (argc < 2)
    {
        cout << "Error: missing argument\n";
        return 1;
    }

    /*
       Note that by convention argv[0] is the name of your executable,
       and the first argument to your program is stored in argv[1]
     */

    task = atoi(argv[1]);
    
    ReadGrammar();  // Reads the input grammar from standard input
                    // and represent it internally in data structures
                    // ad described in project 2 presentation file

    switch (task) {
        case 1: printTerminalsAndNoneTerminals();
            break;

        case 2: RemoveUselessSymbols();
            break;

        case 3: CalculateFirstSets();
            break;

        case 4: CalculateFollowSets();
            break;

        case 5: CheckIfGrammarHasPredictiveParser();
            break;

        default:
            cout << "Error: unrecognized task number " << task << "\n";
            break;
    }
    return 0;
}

