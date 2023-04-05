%{
/*
Kurt Lyell
CS 370 - Compilers
Lab5 - lab5.y
03/01/2023

This file is the parser for the compiler. IIt takes Tokens from Lex parses them and checks if 
they are syntactically correct based on grammar rules in this file. If there is a syntax error
it will print out an error message and the line number where the error occured. 
If it is correct, it will print out the tokens and their values. 

Right Recursion is used in our grammar rules, with one instance of left recursion.

*/ 

#include <stdio.h>
#include <ctype.h>
#include <string.h>


int yylex(); 
extern int mydebug;
extern int linenum;

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


%start Program 
%union {
    char *string;
    int value;
}

%token T_LT T_LE T_GT T_GE T_EQ T_NE


%token <value> T_NUM
%token <string> T_ID
%token T_INT
%token T_VOID
%token T_IF
%token T_ELSE
%token T_WHILE
%token T_RETURN
%token T_READ
%token T_WRITE
%token T_STRING

%%
Program : Declaration_List
        ;

Declaration_List : Declaration /*can have 0 or more*/
        | Declaration Declaration_List
        ;

Declaration : Var_Declaration 
        | Fun_Declaration
        ;

Var_Declaration : Type_Specifier Var_List ';'
        ;

Var_List : T_ID { printf("Var_LIST with value %s\n", $1); }
        | T_ID '[' T_NUM ']' { printf("Var_LIST with value %s\n", $1); }
        | T_ID ',' Var_List { printf("Var_LIST with value %s\n", $1); }
        | T_ID '[' T_NUM ']' ',' Var_List  { printf("Var_LIST with value %s\n", $1); }
        ;

Type_Specifier : T_INT 
        | T_VOID
        ;

Fun_Declaration : Type_Specifier T_ID '(' Params ')' Compound_Stmt { printf("FunDec with value %s\n", $2); }
        ;

Params : T_VOID
        | Param_List
        ;

Param_List : Param
        | Param ',' Param_List
        ;

Param : Type_Specifier T_ID /*can have the [] brackets or not*/ { printf("PARAM with value %s\n", $2);}
        | Type_Specifier T_ID '[' ']' { printf("PARAM with value %s\n", $2);}
        ;

Compound_Stmt : '{' Local_Declarations Statement_List '}'
        ;

Local_Declarations : /*empty*/
        | Var_Declaration Local_Declarations /*can have 0 or more*/
        ;

Statement_List : /*empty*/
        | Statement Statement_List /*can have 0 or more*/
        ;

Statement : Expression_Stmt
        | Compound_Stmt
        | Selection_Stmt
        | Iteration_Stmt
        | Assignment_Stmt
        | Return_Stmt
        | Read_Stmt
        | Write_Stmt
        ;

Expression_Stmt : Expression ';'
        | ';' /*empty followed by semicolon*/
        ;   

Selection_Stmt : T_IF '(' Expression ')' Statement
        | T_IF '(' Expression ')' Statement T_ELSE Statement /*else statement optional*/
        ;

Iteration_Stmt : T_WHILE '(' Expression ')' Statement
        ;

Read_Stmt : T_READ Var ';' 
        ;
Return_Stmt : T_RETURN ';'
        | T_RETURN Expression ';' /*expression optional*/
        ;

Write_Stmt : T_WRITE Expression ';'
        | T_WRITE T_STRING ';'
        ;
Assignment_Stmt : Var '=' Simple_Expression ';'
        ;

Var : T_ID { printf("Var with value %s\n", $1);}
        | T_ID '[' Expression ']' { printf("Var with value %s\n", $1);}
        ;

Expression : Simple_Expression
        ;

Simple_Expression : Additive_Expression
        | Additive_Expression Relop Simple_Expression
        ;

Relop : T_LT
        | T_LE
        | T_GT
        | T_GE
        | T_EQ
        | T_NE
        ;

Additive_Expression : Term
        | Additive_Expression Addop Term
        ;

Addop   : '+'
        | '-'
        ;

Term    : Factor
        | Term Multop Factor
        ;

Multop  : '*'
        | '/'
        ;

Factor  : '(' Expression ')'
        | T_NUM 
        | Var
        | Call
        | '-' Factor
        ;

Call    : T_ID '(' Args ')' { printf("Call with value %s\n", $1);}
        ;

Args    : Arg_List
        | /*empty*/
        ;

Arg_List : Expression
        | Expression ',' Arg_List
        ;

%%

/*
precondtion:
        none
postcondition: 
        yyparse() is called and the program is run
        debug output is turned on if -d is passed in as an argument
*/
int main(int argc, char *argv[])
{ 	
	int i = 1;
	while( i < argc) {
		if(strcmp(argv[i], "-d") == 0) 
			mydebug = 1;
		i++;
	}
	
	yyparse();
	
} // end main()
