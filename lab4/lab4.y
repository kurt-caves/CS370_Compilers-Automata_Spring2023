%{
/*
Kurt Lyell
CS 370 - Compilers
Lab4 - lab4.y
02/19/2023

This file takes tokens created by LEX and based upon grammar rules outlined in this file performs syntax directed semantic action.
Lab 4 builds on lab 2 by adding a symbol table. Users can now declare variables and assign values to them. The symbol table is
is implemented in symbtable.c This program checks for duplicate declarations and undeclared variables. If a variable is declared
that has not been seen we add it to the symbol table as long as our symbol table is not at capacity.

*/


#include <stdio.h>
#include <ctype.h>
#include <string.h> /*added for strcmp*/
#include "symtab.h" /*added for symbol table*/
#include "stdbool.h" /*added for boolean type*/
#define MAX 26


extern int mydebug; /*added for debug option from .l file 01/16/23*/
extern int linenum; /*added for line number during error printing 02/19/23*/
bool var = true; /*added to only print answers when a variable is in the symbol table*/
int offset = 0; /*added for symbol table size*/
int regs[MAX]; /*added for symbol table*/
int base, debugsw;
int yylex(); /*added because of compiler error "y.tab.c:1179:16: warning: implicit declaration of function ‘yylex’ [-Wimplicit-function-declaration]"*/

/*
precondtion:
	none
postcondition:
	prints error message and line number
*/
void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s, On Line: %d\n",s,linenum);
}


%}

/* Change start non terminal to P*/
%start P

/* Added union for our values and strings from tokens in LEX*/
%union {
	int value;
	char *string;
}

/*Added tokens*/
%token <value>INTEGER
%token  <string>VARIABLE
%token T_INT

%type <value> expr stat

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS


%%	/* end specs, begin rules */


P	: DECLS list /*We can have declaratons and a list*/
	;

DECLS : DECLS DECL /*We can have multiple declarations or none*/
	| /* empty */
	;

DECL : T_INT VARIABLE ';' '\n' /*We can have a declaration of type int and a variable*/
	{
		/*If the variable has not been declared before and the symbol table is not full, insert*/
		if((Search($2) == 0) && (offset < MAX)) {
			Insert($2, offset++);
			if(mydebug) printf("Variable %s declared\n", $2);
			var = true;
		}
		/*Symbol table is full, print error*/
		else if(offset == MAX) {
			var = false;
			printf("Error: Table is at capacity, cannot declare %s\n", $2);
		}
		/*Variable is already declared, print error*/
		else {
			printf("Error: Variable %s already declared\n", $2);
		}
	}
	;

list	:	/* empty */
	|	list stat '\n'
	|	list error '\n'
			{ yyerrok; }
	;

stat	:	expr
			{ /*only print for variables that are in the symbol*/
				if(var != false) fprintf(stderr,"the anwser is: %d\n", $1); 
			}
	|	VARIABLE '=' expr
			{ 	/*when intializing a variable we have to check if its in the symbol table first
					if its there we get its address and initialize it to the expression*/
				if(Search($1) != 0) {
					regs[FetchAdd($1)] = $3;
					var = true;
				}
				/*if its not in the symbol table we print an error*/
				else {
					printf("Error: Variable %s not defined\n", $1);
				}
			}
	;

expr	:	'(' expr ')'
			{ $$ = $2; }
	|	expr '-' expr
			{ $$ = $1 - $3; }
	|	expr '+' expr
			{ $$ = $1 + $3; }
	|	expr '*' expr
			{ $$ = $1 * $3; /*added semantic action for the gramar of multiplication */}
	|	expr '/' expr
			{ $$ = $1 / $3; }
	|	expr '%' expr
			{ $$ = $1 % $3; }
	|	expr '&' expr
			{ $$ = $1 & $3; }
	|	expr '|' expr
			{ $$ = $1 | $3; }
	|	'-' expr	%prec UMINUS
			{ /*removed the $1 expr. Here %prec is used to tell YACC that an expr with '-' infront 
			 	of it takes precendence. */
				$$ = -$2; }
	|	VARIABLE
			{ 
				/*check if variable is in symbol table, if it is our variables value is set*/
				if(Search($1) != 0) {
					$$ = regs[FetchAdd($1)];
					var = true;
				}

				/*if its not in the symbol table we print an error*/
				else {
					var = false;
					printf("Error: Variable %s not defined\n", $1);
				}
				if(debugsw) fprintf(stderr,"found a variable value: %d\n",$1); /*added if statement for debug 01/16/2023*/
			}
	|	INTEGER 
            {$$=$1; if(debugsw) fprintf(stderr,"found an integer: \n"); /*added if statement for debug 01/16/2023*/}
	;



%%	/* end of rules, start of program */

// main function
// precondtion: 
//	if -d is passed in as an argument, debug mode is turned on
// postcondition:
//	program runs

int main(int argc, char *argv[])
{ 	
	int i = 1;
	while( i < argc) {
		if(strcmp(argv[i], "-d") == 0) 
			debugsw = 1;
			mydebug = 1;
		i++;
	}
	
	yyparse();
	
} // end main()
