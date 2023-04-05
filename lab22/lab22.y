%{
/*
Kurt Lyell
CS 370 - Compilers
Lab22 - lab22.y
01/26/2023

This file takes tokens created by LEX and based upon grammar rules outlined in this file performs syntax directed semantic action.
The purpose of this program is to function as a basic calculator that follows PEMDAS.

*/


#include <stdio.h>
#include <ctype.h>
#include <string.h> /*added for strcmp*/
/*removed the include for yy.lex.c 01/16/23*/

extern int mydebug; /*added for debug option from .l file 01/16/23*/
int regs[26];
int base, debugsw;
int yylex(); /*added because of compiler error "y.tab.c:1179:16: warning: implicit declaration of function ‘yylex’ [-Wimplicit-function-declaration]"*/

/*
precondtion: 
*/
void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s\n", s);
}


%}
/*  defines the start symbol, what values come back from LEX and how the operators are associated  */

%start list

%token INTEGER
%token  VARIABLE

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS


%%	/* end specs, begin rules */

list	:	/* empty */
	|	list stat '\n'
	|	list error '\n'
			{ yyerrok; }
	;

stat	:	expr
			{ fprintf(stderr,"the anwser is: %d\n", $1); }
	|	VARIABLE '=' expr
			{ regs[$1] = $3; }
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
			{ $$ = regs[$1]; if(debugsw) fprintf(stderr,"found a variable value: %d\n",$1); /*added if statement for debug 01/16/2023*/}
	|	INTEGER {$$=$1; if(debugsw) fprintf(stderr,"found an integer: \n"); /*added if statement for debug 01/16/2023*/}
	;



%%	/* end of rules, start of program */

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
	
}
