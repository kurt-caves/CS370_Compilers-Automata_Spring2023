// Kurt Lyell
// CS 370 -- Compilers
// Lab6 - ast.h
// 03/22/2023

// This file contains the definitions for the AST which is used to represent the abstract syntax tree.
// The AST is a binary tree with a root node and two children, and a next pointer to the next node in the list.
// AST traversal is achieved through our next connections.

#include<stdio.h>
#include<malloc.h>
#include"symtable.h"

#ifndef AST_H
#define AST_H
int mydebug;

// AST node types
enum ASTtype {
   A_FUNCTIONDEC, // 0
   A_VARDEC, // 1
   A_COMPOUND, // 2
   A_WRITE, // 3
   A_NUM, // 4
   A_VAR, // 5
   A_EXPRESSION, // 6 
   A_PARAM, // 7
   A_READ, // 8
   A_ASSIGN, // 9
   A_IF, // 10
   A_ARG, // 11
   A_IFBODY, // 12
   A_WHILE, // 13
   A_RETURN, // 14
   A_CALL, // 15
   A_EXPRSTMT, // 16
   A_ARGLIST  // 17
}; // end of ASTtype

// Math Operators
enum AST_OPERATORS {
   A_PLUS,
   A_MINUS,
   A_TIMES,
   A_DIVIDE,
   A_EQ,
   A_LE,
   A_GT,
   A_GE,
   A_LT,
   A_NE,
   A_MOD,
   A_UMINUS
   
}; // end of AST_OPERATORS

// Data Types
enum AST_MY_DATA_TYPE {
   A_INTTYPE,
   A_VOIDTYPE

}; // end of AST_MY_DATA_TYPE


// Our AST node can have a type, an operator, a name, a value, a data type, and pointers to other AST nodes
// AST tree has a root node and two children as well as a next pointer
typedef struct ASTnodetype
{
     enum ASTtype type;
     enum AST_OPERATORS operator;
     char * name;
     int value;
     enum AST_MY_DATA_TYPE my_data_type;
     struct SymbTab *symbol;
     
     struct ASTnodetype *s1,*s2, *next ; 
} ASTnode;
// end of ASTnodetype

/* uses malloc to create an ASTnode and passes back the heap address of the newley created node */
ASTnode *ASTCreateNode(enum ASTtype mytype);

// print function that prints out spaces to represent the level of the nodes in the tree
void PT(int howmany);


// print function that prints out the AST to the terminal
void ASTprint(int level,ASTnode *p);

// check formal parameters against actual parameters
int check_params(ASTnode *p, ASTnode *q);

#endif // of AST_H
