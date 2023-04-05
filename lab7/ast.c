// Kurt Lyell
// CS 370 -- Compilers
// Lab6 - ast.c
// 03/29/2023

// This file contains the functions for our Abstract Syntax Tree which are defined in ast.h. 
// The AST is a binary tree with a root node and two children, and a next pointer to the next node in the list.
// Based on the grammar rules in our YACC file and tokens supplied by the lexer, we create an AST and print it to
// the terminal. The grammar rules are defined in the YACC file and are based on the grammar rules for the C- language.
// We supply a C file with some code to have it printed out. The structure of the AST is represented visually
// through our ASTprint function where we print out the AST in a tree structure based on terminals nodes and indentations
// provided by our helper function PT.

#include<stdio.h>
#include<malloc.h>
#include "ast.h"





//  PRE:  Ast Node Type
//  POST:   Pointer to memory address on the heap of root node, all other pointers set to NULL
//          Malloc is used to allocate memory for the node 
ASTnode *ASTCreateNode(enum ASTtype mytype)

{
    ASTnode *p;
    if (mydebug) fprintf(stderr,"Creating AST Node \n");
    p=(ASTnode *)malloc(sizeof(ASTnode));
    p->type=mytype;
    p->s1=NULL;
    p->s2=NULL;
    p->next=NULL;
    p->value=0;
    return(p);
} // end of ASTCreateNode

// Function used to print spaces for indentation, mimics the structure of the AST
// PRE:  Number of spaces to print
// POST:  Desired number of spaces printed to the terminal
void PT(int howmany)
{
	 for(int i=0;i<howmany;i++) printf(" ");
} // end of PT

//  PRE:  A declaration type
//  POST:  A character string that is the name of the type
//          Typically used in formatted printing

// This function is used to convert the enum type to a string for printing
// PRE:  A declaration type
// POST: Declared type returned as a string
char * ASTtypeToString(enum AST_MY_DATA_TYPE mytype )
{
    // switch on the supplied type and return the string
    switch(mytype) {
    case A_INTTYPE: 
      return("INT");
      break;
    case A_VOIDTYPE:
      return("VOID");
      break;
    default: return("UNKNOWN");
    } // end of switch

} // end of ASTtypeToString


// Main driver function for printing the AST
// PRE:  Level of indentation, ASTnode
// POST:  AST printed to the terminal with indentation that mimics the structure of the AST
void ASTprint(int level,ASTnode *p)
{
   int i;
   if (p == NULL ) return; // when we reach the end of the tree, return

  // switch on the type of the node and print the appropriate information
  switch (p->type) {

  // function declaration(s), parameters in s1, compound statement in s2
  // next is the next function declaration
  case A_FUNCTIONDEC :
    PT(level);
    printf("Function %s %s level %d offset %d\n",ASTtypeToString(p->my_data_type), 
    p->name,
    p->symbol->level,
    p->symbol->offset
    );
    ASTprint(level+1,p->s1); // print the parameters
    ASTprint(level+1,p->s2); // print the compound statement
    ASTprint(level,p->next); // print the next function
    PT(level);
    break;

  // variable declaration(s), next is the next variable declaration
  // value greater than 0 means array of that size, 0 means a scalar
  // variable declarations store values in s1 and are next connected
  case A_VARDEC : 
    PT(level);
    if(p->value > 0) printf("Variable %s %s  [%d] level %d offset %d\n",ASTtypeToString(
      p->my_data_type),
      p->name,
      p->value,
      p->symbol->level,
      p->symbol->offset
      );
    if(p->value == 0) printf("Variable %s %s level %d offset %d\n",ASTtypeToString(
      p->my_data_type),
      p->name,
       p->symbol->level,
      p->symbol->offset
      );
    ASTprint(level,p->s1);
    ASTprint(level,p->next);
    break;

  // reference to a variable or array element
  case A_VAR:
    PT(level);
    if(p->value < 0) {
      printf("VARIABLE %s level %d offset %d\n",p->name,
      p->symbol->level,
      p->symbol->offset
      );
      PT(level+1);
      printf("[\n");
      ASTprint(level+1,p->s1); // print the expression
      PT(level+1);
      printf("]\n");
    } // end of if
    else if(p->value == 0) printf("VARIABLE %s level %d offset %d\n",p->name,
    p->symbol->level,
    p->symbol->offset
    );
    break;

  // parameters of a function, either an array or scalar
  case A_PARAM:
    PT(level);
    if(p->value > 0) {
      printf("Parameter %s %s[] \n", ASTtypeToString(p->my_data_type), p->name);
    } // end of if
    else {
      printf("Parameter %s %s \n", ASTtypeToString(p->my_data_type), p->name);
    } // end of else
    ASTprint(level,p->s1);
    ASTprint(level,p->next);
    break;

  // functions have local declarations in s1 and a statement list in s2
  case A_COMPOUND:
    PT(level); 
    printf("Compound Statement\n");
    ASTprint(level+1,p->s1); // local declarations
    ASTprint(level+1,p->s2); // statement list
    ASTprint(level,p->next); // added for next statement
    break;

  // write statement, s1 is the expression to write
  // additional statements are next connected
  // if name is not NULL, then it is a string to write
  case A_WRITE :
    PT(level);
    printf("Write Expression\n");
    if(p->name != NULL) printf("Write String %s\n",p->name);
    ASTprint(level+1,p->s1);
    ASTprint(level,p->next);
    break;

  // read statement, s1 is the variable to read into
  // additional statements are next connected
  case A_READ :
    PT(level); 
    printf("READ STATEMENT \n");
    ASTprint(level+1,p->s1);
    ASTprint(level,p->next);
    break;
  
  // assignment statement, s1 is the variable, s2 is the expression
  // additional statements are next connected
  case A_ASSIGN:
    PT(level);
    printf("ASSIGNMENT STATEMENT\n");
    ASTprint(level+1,p->s1);
    PT(level);
    printf("is assigned\n");
    ASTprint(level+1,p->s2);
    ASTprint(level,p->next);
    break;
  
  // if statement with optional else. When we are here, we have already
  // printed the IF statement and expression in its s1, s2 contatins
  // additional statements. the s2 is the body of the if statement and if the 
  // the body has an s2, then it is the body of the else statement
  // additional statements are next connected
  case A_IFBODY:
    PT(level);
    printf("IF body\n");
    ASTprint(level+1,p->s1);
    if(p->s2 != NULL) {
      PT(level);
      printf("ELSE BODY\n");
      ASTprint(level+1,p->s2);
    } // end of if
    // ASTprint(level,p->next); removed from lab6 grade
    break;
  
  // if statement, s1 is the expression, s2 is the body
  // additional statements are next connected
  case A_IF:
    PT(level);
    printf("IF STATEMENT\n");
    PT(level+1);
    printf("IF expression\n");
    ASTprint(level+1,p->s1);
    ASTprint(level+1,p->s2);
    ASTprint(level,p->next);
    break;

  // iteration statement, s1 is the expression, s2 is the body
  // additional statements are next connected
  case A_WHILE:
    PT(level);
    printf("WHILE STATEMENT\n");
    PT(level+1);
    printf("WHILE expression \n");
    ASTprint(level+1,p->s1);
    PT(level+1);
    printf("WHILE body \n");
    ASTprint(level+1,p->s2);
    ASTprint(level,p->next);
    break;

  // return statement, s1 is the expression
  // additional statements are next connected
  case A_RETURN:
    PT(level);
    printf("RETURN STATEMENT \n");
    ASTprint(level+1,p->s1);
    ASTprint(level,p->next);
    break;

  // expression statement, s1 is the expression
  // additional statements are next connected
  case A_EXPRSTMT:
    PT(level);
    printf("Expression STATEMENT\n");
    ASTprint(level+1,p->s1);
    ASTprint(level,p->next);
    break;

  // leaf node containing a number
  case A_NUM:
    PT(level+1);
    printf("NUMBER value %d\n",p->value);
    break;

  // expression, if there is an operator on the root node we switch
  // on the type of operator otherwise we print the expression and
  // access the left and right children through s1 and s2
  case A_EXPRESSION:
    PT(level);
    printf("EXPRESSION ");
    switch (p->operator)
    {
      case A_MINUS:
        printf("operator MINUS\n");
        break;
      case A_PLUS:
        printf("operator PLUS\n");
        break;
      case A_TIMES:
        printf("operator TIMES\n");
        break;
      case A_DIVIDE:
        printf("operator DIVIDE\n");
        break;
      case A_MOD:
        printf("operator MOD\n");
        break;
      case A_LT:
        printf("operator <\n");
        break;
      case A_GT:
        printf("operator >\n");
        break;
      case A_LE:
        printf("operator <=\n");
        break;
      case A_GE:
        printf("operator >=\n");
        break;
      case A_EQ:
        printf("operator ==\n");
        break;
      case A_NE:
        printf("operator !=\n");
        break;
      case A_UMINUS:
        printf("operator Unary-minus\n");
        break;
      default: printf("unknown operator in A_EXPR in ASTPrint in ASTprint\n");
        break;
      } // end switch
    ASTprint(level+1,p->s1);
    ASTprint(level+1,p->s2);
    break;

  // function call with a name and a list of arguments
  // the arguments are in the s1 field and can be null, 
  // be a single argument or a list of arguments
  case A_CALL:
    PT(level);
    printf("CALL STATEMENT function %s\n",p->name);
    PT(level+1); printf("(\n"); 
    if(p->s1 == NULL) {
      PT(level+1);
      printf("NULL\n"); // we can have a function and a function with no arguments
    } // end of if
    // then we have arguments to print
    else {   
      PT(level+1); 
      
      ASTprint(level,p->s1);
    } // end of else
    PT(level+1); printf(")\n");
    break;
  
  // argument list, s1 is the argument
  // additional arguments are next connected
  case A_ARG:
    printf("CALL argument\n");
    ASTprint(level+1,p->s1);
    PT(level);
    
    ASTprint(level,p->next);
    break;

  // we have reached a node that we do not know about
  default: printf("unknown AST Node type %d in ASTprint\n", p->type);


  } // end main astprint switch
     

} // end ASTprint


// PRE: p is a pointer actual parameters and q is a pointer to the formal parameters
// POST: returns 1 if the parameters match, 0 otherwise
int check_params(ASTnode *p, ASTnode *q) {
  
  // if both are null, then they match
  // also base case for recursion
  if(p == NULL && q == NULL) return 1;
  

  // if one is null and the other is not, then they do not match
  if(p == NULL || q == NULL) return 0;
  
  // if the types do not match, then they do not match
  // my_data_type not type!
  if(p->my_data_type != q->my_data_type) return 0;
  
  // if the types match, then we need to check the next parameter
  // easy to do with recursion
  return check_params(p->next,q->next);
  
}

