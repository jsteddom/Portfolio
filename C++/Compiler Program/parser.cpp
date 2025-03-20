#include <cstdlib>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>
#include "compiler.h"
#include "lexer.h"
#include "inputbuf.h"
#include <map>
#include <vector>
#include <iostream>
using namespace std;
// Head of linked list
InstructionNode* head = nullptr;
// Importing lexer 
LexicalAnalyzer lexer;
// Map for variables
map <string, int> location; 
// Vector of Nodes
vector<InstructionNode*> nodes;
// Vector of inputs
//vector<int> inputs;

void parse_Program();
void parse_var_section();
void parse_id_list();
void parse_body();
void parse_stmt_list();
void parse_stmt();
void parse_stmtTwo();
void parse_assign_stmt();
//void parse_assign_stmtTwo();
void parse_expr();
int parse_primary();
ArithmeticOperatorType parse_op();
void parse_output_stmt();
void parse_input_stmt();
void parse_while_stmt();
void parse_if_stmt();
void parse_condition();
ConditionalOperatorType parse_relop();
void parse_switch_stmt();
void parse_switch_stmtTwo(int addy);
void parse_for_stmt();
void parse_case_list();
void parse_case();
void parse_default_case();
void parse_inputs();
void parse_num_list();
void parse_num_listTwo();
InstructionNode* parse_For_For_Loop();

int isOp();
/*

start with inputs outputs assign

vector of nodes
*/


struct InstructionNode * parse_generate_intermediate_representation()
{ 
    parse_Program();
    //head = nodes[0];
    InstructionNode* current = nullptr;
    if (head == nullptr){
      head = nodes[0];
      current = nodes[0];
      head->next = nodes[1];
    }
    for (auto & element : nodes) {
    current->next = element;
    current = current->next;
}
/*
    for (int i = 1; i < nodes.size(); i++){
        current->next = nodes[i];
        current = current->next;
    }
    */
    /*
    if (current != nullptr){
        current->next = NULL;
    }
*/
    return head;
}

void parse_Program(){
    parse_var_section();
    parse_body();
    parse_inputs();
}

void parse_var_section(){
   parse_id_list();
   // Check SEMICOLON 
   Token token = lexer.GetToken();
   if (token.token_type == SEMICOLON)
        return;
}

void parse_id_list(){
    //Parse ID COMMA
    Token token = lexer.GetToken();
    location[token.lexeme] = next_available;
    mem[next_available] = 0;
    next_available++;
    token = lexer.peek(1);
    if (token.token_type == COMMA){
        lexer.GetToken();
        parse_id_list();
    }
}
void parse_body(){
   // Parse LBRACE
   Token token = lexer.GetToken();
   // Parse statement list
   parse_stmt_list();
   // Parse RBRACE
   token = lexer.GetToken();
    // At end
}
void parse_stmt_list(){
    Token token = lexer.peek(1);
    parse_stmt();
    if (token.token_type != RBRACE){
    //Error
       parse_stmt_list();
   }
   
}

void parse_stmt(){
  Token token = lexer.peek(1);
  //token = lexer.GetToken();
    switch(token.token_type){
        case ID:
            parse_assign_stmt();
            break;
	    
        case WHILE:
            parse_while_stmt();
            break;
            
        case IF: 
        //cout << "we made it!";
            parse_if_stmt();
            break;
        
        case SWITCH: 
            parse_switch_stmt();
            break;
        case FOR:
            parse_for_stmt();
            break;
	    
        case INPUT:
            parse_input_stmt();
            break;
        case OUTPUT:
            parse_output_stmt();
            break;
        default:
	  InstructionNode* node = new InstructionNode;
	  node->type = NOOP;
	  node->next = NULL;
	  nodes.push_back(node);
            break;
        
    }
}
void parse_assign_stmt() {
    // Create an instruction node
    InstructionNode* node = new InstructionNode;
    // Get ID
    Token token = lexer.GetToken();
    // Add ID to node
                                                            //int tokenNUM = stoi(token.lexeme);
    // Get address
    int address = location.find(token.lexeme)->second;
    node->type = ASSIGN;
    node->next = NULL;
    node->assign_inst.left_hand_side_index = address;
    // Consume Equal
    lexer.GetToken();

    token = lexer.peek(1);
    Token tokenTwo = lexer.peek(2);


    if ((token.token_type == ID || token.token_type == NUM) && tokenTwo.token_type == SEMICOLON){
        // Get address of primary value
        int addy = parse_primary();
        // No operand 2
        node->assign_inst.op = OPERATOR_NONE;
        // assign index to address of primary 
        node->assign_inst.operand1_index = addy;
    }
    else{       //if (token.token_type == ID && tokenTwo.token_type == M)
        // Get address of primary value
        int addy = parse_primary();
        // assign index to address of primary 
        node->assign_inst.operand1_index = addy;
        // Get operator
        node->assign_inst.op = parse_op();
        // Get address of second primary value
        addy = parse_primary();
        // assign index to address of primary 
        node->assign_inst.operand2_index = addy;
    }            
    // Consume Semicolon
    lexer.GetToken();
    nodes.push_back(node);
}

ArithmeticOperatorType parse_op(){
    Token token = lexer.GetToken();
    switch (token.token_type){
        case PLUS: 
            return OPERATOR_PLUS;
            break;
        case MINUS:
            return OPERATOR_MINUS;
            break;
        case MULT:
            return OPERATOR_MULT;
            break;
        case DIV:
            return OPERATOR_DIV;
            break;
        default:
	  return OPERATOR_NONE;
	  break;
    }
}

int parse_primary(){
    Token operand = lexer.GetToken();
    auto search = location.find(operand.lexeme);
        if (search != location.end()) {
            return search->second;
        }
        else {
            int index = next_available;
            mem[next_available] = stoi(operand.lexeme);
            location[operand.lexeme] = next_available;
            next_available++;
            return index;
        }
    //    location[token.lexeme] = next_available;
    // int address = next_available;
    // mem[next_available] = stoi(token.lexeme);
    // next_available++;
    //return address;
}



void parse_inputs(){
    Token token = lexer.GetToken();
    int tokenNum = stoi(token.lexeme);
    inputs.push_back(tokenNum);
    
    token = lexer.peek(1);
    if (token.token_type == NUM){
        parse_inputs();    
    }
}

void parse_input_stmt(){
    // Consume input token
    lexer.GetToken();
    // Create an instruction node
    InstructionNode* node = new InstructionNode;
    // Get Input token
    node->type = IN;
    node->next = NULL;
    // Get address of ID
    Token token = lexer.GetToken();
    int address = location.find(token.lexeme)->second;
    // Put address in node
    node->input_inst.var_index = address;
    // Consume Semicolon
    lexer.GetToken();
    // Add node to vector of nodes
    nodes.push_back(node);
}
void parse_output_stmt(){
    // Consume input token
    lexer.GetToken();
    // Create an instruction node
    InstructionNode* node = new InstructionNode;
    // Get Input token
    node->type = OUT;
    node->next = NULL;
    // Get address of ID
    Token token = lexer.GetToken();
    int address = location.find(token.lexeme)->second;
    // Put address in node
    node->input_inst.var_index = address;
    // Consume Semicolon
    lexer.GetToken();
    // Add node to vector of nodes
    nodes.push_back(node);
}
void parse_if_stmt(){
    // Consume IF token
    lexer.GetToken();
    // Create an instruction node
    InstructionNode* node = new InstructionNode;
    node->type = CJMP;
    node->next = NULL;
    // Get address of primary value
    int addy = parse_primary();
    // assign index to address of primary 
    node->assign_inst.operand1_index = addy;
    // Get operator
    node->cjmp_inst.condition_op = parse_relop();
    // Get address of second primary value
    addy = parse_primary();
    // assign index to address of primary 
    node->assign_inst.operand2_index = addy;
    
    // Get size of vector
    int vSize = nodes.size();
    parse_body();

    // Create NOOP node
    InstructionNode* noopNode = new InstructionNode;
    noopNode ->type = NOOP;
    noopNode ->next = NULL;
    // Set inst.target to this node
    node->cjmp_inst.target = noopNode;
    // Insert IF node at vSize index
    nodes.push_back(noopNode);
    nodes.insert(nodes.begin() + vSize, node);
    // Consume Right brace
    //lexer.GetToken();
}
void parse_while_stmt(){
    // Consume WHILE token
    lexer.GetToken();
    // Create an instruction node
    InstructionNode* node = new InstructionNode;
    node->type = CJMP;
    node->next = NULL;
     // Get address of primary value
    int addy = parse_primary();
    // assign index to address of primary 
    node->assign_inst.operand1_index = addy;
    // Get operator
    node->cjmp_inst.condition_op = parse_relop();
    // Get address of second primary value
    addy = parse_primary();
    // assign index to address of primary 
    node->assign_inst.operand2_index = addy;
    
    // Get size of vector
    int vSize = nodes.size();
    parse_body();

    // Create NOOP node
    InstructionNode* returnNode = new InstructionNode;
    returnNode->type = JMP;
    returnNode->jmp_inst.target = node;
    InstructionNode* noopNode = new InstructionNode;
    noopNode->type = NOOP;
    noopNode->next = NULL;
    // Set inst.target to this node
    node->cjmp_inst.target = noopNode;
    // Push JUMP node, THEN push the NOOP node
    nodes.push_back(returnNode);
    nodes.push_back(noopNode);
    // Insert WHILE node at vSize index
    nodes.insert(nodes.begin() + vSize, node);
}

ConditionalOperatorType parse_relop(){
    Token token = lexer.GetToken();
    switch (token.token_type){
        case GREATER:
            return CONDITION_GREATER;
            break;
        case LESS: 
            return CONDITION_LESS;
            break;
        case NOTEQUAL:
            return CONDITION_NOTEQUAL;
            break;
        default: 
            break;
    }
    return CONDITION_GREATER;
}

void parse_for_stmt(){
    // Consume FOR/LPAREN token
    lexer.GetToken();
    lexer.GetToken();
    // Parse first assingment statement
    parse_assign_stmt();
    // Parse condition
    InstructionNode* node = new InstructionNode;
    node->type = CJMP;
    node->next = NULL;
    // Get address of primary value
    int addy = parse_primary();
    // assign index to address of primary 
    node->assign_inst.operand1_index = addy;
    // Get operator
    node->cjmp_inst.condition_op = parse_relop();
    // Get address of second primary value
    addy = parse_primary();
    // assign index to address of primary 
    node->assign_inst.operand2_index = addy;

    // Parse SEMICOLON
    lexer.GetToken();

    // Parse next assingment statement
    InstructionNode* assingmentTwo = parse_For_For_Loop();

    // Consume RPAREN
    lexer.GetToken();

    // Get size of vector
    int vSize = nodes.size();

    // Parse Body
    parse_body();

    // Create NOOP node
    InstructionNode* returnNode = new InstructionNode;
    returnNode->type = JMP;
    returnNode->jmp_inst.target = node;
    InstructionNode* noopNode = new InstructionNode;
    noopNode->type = NOOP;
    noopNode->next = NULL;
    // Set inst.target to this node
    node->cjmp_inst.target = noopNode;
    // Push AssingmentTwo node, THEN JUMP node, THEN push the NOOP node
    nodes.push_back(assingmentTwo);
    nodes.push_back(returnNode);
    nodes.push_back(noopNode);
    // Insert WHILE node at vSize index
    nodes.insert(nodes.begin() + vSize, node);


}

InstructionNode* parse_For_For_Loop(){
    // Create an instruction node
    InstructionNode* node = new InstructionNode;
    // Get ID
    Token token = lexer.GetToken();
    // Add ID to node
                                                            //int tokenNUM = stoi(token.lexeme);
    // Get address
    int address = location.find(token.lexeme)->second;
    node->type = ASSIGN;
    node->next = NULL;
    node->assign_inst.left_hand_side_index = address;
    // Consume Equal
    lexer.GetToken();

    token = lexer.peek(1);
    Token tokenTwo = lexer.peek(2);


    if ((token.token_type == ID || token.token_type == NUM) && tokenTwo.token_type == SEMICOLON){
        // Get address of primary value
        int addy = parse_primary();
        // No operand 2
        node->assign_inst.op = OPERATOR_NONE;
        // assign index to address of primary 
        node->assign_inst.operand1_index = addy;
    }
    else{       //if (token.token_type == ID && tokenTwo.token_type == M)
        // Get address of primary value
        int addy = parse_primary();
        // assign index to address of primary 
        node->assign_inst.operand1_index = addy;
        // Get operator
        node->assign_inst.op = parse_op();
        // Get address of second primary value
        addy = parse_primary();
        // assign index to address of primary 
        node->assign_inst.operand2_index = addy;
    }            
    // Consume Semicolon
    lexer.GetToken();
    return node;
}

void parse_switch_stmt(){
    // Consume SWITCH token
    lexer.GetToken();
    // Get ID
    int addy = parse_primary();
    // Consume LBRACE
    lexer.GetToken();
    // Create Instruction node
    parse_switch_stmtTwo(addy);
    // Consume RBRACE
    lexer.GetToken();
}

void parse_switch_stmtTwo(int addy){
    // Create a node
    InstructionNode* node = new InstructionNode;
    // Create tempNode that will jump to if condition true
    InstructionNode* tempNode = new InstructionNode;
    tempNode->type = NOOP;
    tempNode->next = NULL;
    // Create tempNode that will jump to end of switch case
    InstructionNode* tempNodeTwo = new InstructionNode;
    tempNodeTwo->type = NOOP;
    tempNodeTwo->next = NULL;
    
    InstructionNode* bodyFinishNode = new InstructionNode;
    bodyFinishNode->type = JMP;
    bodyFinishNode->jmp_inst.target = tempNodeTwo;
    // Create node for true statement
    InstructionNode* trueNode = new InstructionNode;
    trueNode->type = JMP;
    trueNode->jmp_inst.target = tempNode;
    // Create node for false statement
    InstructionNode* falseNode = new InstructionNode;
    falseNode->type = NOOP;
    falseNode->next = NULL;
    // Consume CASE token
    lexer.GetToken();
   
    // Fill in node
    node->type = CJMP;
    node->cjmp_inst.condition_op = CONDITION_NOTEQUAL;
    node->cjmp_inst.operand1_index = addy;
    node->cjmp_inst.operand2_index = parse_primary();
    node->cjmp_inst.target = falseNode;
    // Get size of vector
    int vSize = nodes.size();
    // Parse Colon
    lexer.GetToken();
    // Parse Body
    parse_body();
    // Push nodes
    nodes.push_back(bodyFinishNode);
    nodes.push_back(tempNode);
    nodes.insert(nodes.begin() + vSize, node);
    nodes.insert(nodes.begin() + vSize + 1, trueNode);
    nodes.insert(nodes.begin() + vSize + 2, falseNode);

    // Check next token
    Token token = lexer.peek(1);
    if (token.token_type == CASE){
        parse_switch_stmtTwo(addy);
    }
    else if (token.token_type == DEFAULT){
        // Consume default and colon token
        lexer.GetToken();
        lexer.GetToken();
        parse_body();
        //nodes.push_back(tempNodeTwo);
    }
    else{
    	//nodes.push_back(tempNodeTwo);
    }
    nodes.push_back(tempNodeTwo);
}
