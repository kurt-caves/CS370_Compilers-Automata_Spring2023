%{
/*
Kurt Lyell
CS 370 - Compilers
Lab6 - lab6.y
03/29/2023

This YACC file is used to create a parser for the C- language. 
The parser will create an AST (Abstract Syntax Tree) based on grammar rules,
and tokens from the scanner (lab6.l). Syntax directed semantics action code
has been added to the C- grammar rules from lab5.y. The AST is currently
being printed to the console based upon grammar rules in this file and the
and the AST which is utilized from the ast.c file. The data structure for the 
AST is defined in the ast.h file and is a tree of nodes, child nodes s1 and s2,
and a next node. The AST is a linked list of nodes. By traversing the AST
in the ast.c file, specifically the ASTprint function an AST can be printed.
*/ 

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "ast.h"

ASTnode *PROGRAM;


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
    int value; // value of a number
    char * string; // string of a variable
    ASTnode *node; // node of the AST
    enum AST_MY_DATA_TYPE d_type; // data type of a variable
    enum AST_OPERATORS op; // operator of an expression
}

%token T_LT T_LE T_GT T_GE T_EQ T_NE // relational operators

// terminal tokens
%token <value> T_NUM
%token <string> T_ID T_STRING
%token T_INT
%token T_VOID
%token T_IF
%token T_ELSE
%token T_WHILE
%token T_RETURN
%token T_READ
%token T_WRITE
%token T_MOD


// non-terminals used in grammar
%type <node> Declaration_List Declaration Var_Declaration Var_List Fun_Declaration Params Compound_Stmt
%type <node> Local_Declarations Statement_List Statement Write_Stmt Expression 
%type <node> Simple_Expression Additive_Expression Term Factor Var Call Args Arg_List
%type <node> Param Param_List Read_Stmt Assignment_Stmt Expression_Stmt
%type <node> Selection_Stmt Iteration_Stmt Return_Stmt


%type <op> Addop Multop Relop
%type <d_type> Type_Specifier


%%
Program : Declaration_List 
        { 
                PROGRAM = $1; /*top of the tree*/
        }
        ;

// declaration list can be a declaration or many declarations next connected
Declaration_List : Declaration 
        { 
                $$ = $1; 
        }
        | Declaration Declaration_List 
        {
                $$ = $1; 
                $$->next = $2;
        } 
        ;

// declaration can be a variable declaration or a function declaration
Declaration : Var_Declaration 
        { 
                $$ = $1; 
        }
        | Fun_Declaration 
        { 
                $$ = $1;
        }
        ;

// variable declaration can be a single variable or a list of variables with a type INT or VOID
// s1 is used to connect the list of variables
Var_Declaration : Type_Specifier Var_List ';'
        { 
                ASTnode *p = $2;

                /*set the type of all the variables in the s1 connected list 
                with defined type via $1*/
                while(p != NULL) {
                        p->my_data_type = $1;
                        p = p->s1;
                }
                $$ = $2;
        }
        ;

// variable list can be a single variable or a list of variables that are scalars or arrays
// values are s1 connected, more variables are next connected
Var_List : T_ID 
        {
                $$ = ASTCreateNode(A_VARDEC);
                $$->name = $1;
                $$->value = 0; // scalar
        }
        | T_ID '[' T_NUM ']' 
        {
                $$ = ASTCreateNode(A_VARDEC);
                $$->name = $1;
                $$->value = $3;
        }
        | T_ID ',' Var_List
        { 
                $$ = ASTCreateNode(A_VARDEC); 
                $$->name = $1; 
                $$->s1 = $3; 
        }
        | T_ID '[' T_NUM ']' ',' Var_List 
        {
                $$ = ASTCreateNode(A_VARDEC);
                $$->name = $1;
                $$->value = $3;
                $$->next = $6;
        }
        ;

// types of variables and functions can be INT or VOID
Type_Specifier : T_INT 
        { 
                $$ = A_INTTYPE;
        }
        | T_VOID 
        {
                $$  = A_VOIDTYPE;
        }
        ;

// when a function is declared it has a return type, name, parameters, and a compound statement
Fun_Declaration : Type_Specifier T_ID '(' Params ')' Compound_Stmt 
        {
                $$ = ASTCreateNode(A_FUNCTIONDEC);
                $$->name = $2;
                $$->my_data_type = $1;
                $$->s1 = $4; // parameters of function
                $$->s2 = $6; // compound statement (stuff inside function)
        }
        ;

// parameters can be a list of parameters, or null
Params : T_VOID 
        {
                $$ = NULL;
        }
        | Param_List 
        {
                $$ = $1;
        }
        ;

// parameter list can be a single parameter or a list of parameters
// parameters are next connected
Param_List : Param 
        {
                $$ = $1;
                
        }
        | Param ',' Param_List
        {      
                $$ = $1;
                $$->next = $3;
        }
        ;

// parameter must have a type a name, and can be a scalar or array
Param : Type_Specifier T_ID /*can have the [] brackets or not*/ 
        {
                $$ = ASTCreateNode(A_PARAM);
                $$->name = $2;
                $$->my_data_type = $1;
                $$->value = 0; // scalar
        }
        | Type_Specifier T_ID '[' ']' 
        {
                $$ = ASTCreateNode(A_PARAM);
                $$->name = $2;
                $$->my_data_type = $1;
                $$->value = 1; // array
        }
        ;

// compound statement can have local declarations and a statement list
Compound_Stmt : '{' Local_Declarations Statement_List '}' 
        {      
                $$ = ASTCreateNode(A_COMPOUND);
                $$->s1 = $2; // local or var declarations
                $$->s2 = $3; // statements

        }
        ;

// declarations inside a function can be null or a list of declarations
// that next connected
Local_Declarations : /*empty*/ { $$ = NULL; }
        | Var_Declaration Local_Declarations /*can have 0 or more*/ 
        { 
                $$ = $1; 
                $$->next = $2;
        }
        ;

// statement list can be null or a list of statements that are next connected
Statement_List : /*empty*/ { $$ = NULL; }
        | Statement Statement_List /*can have 0 or more*/ 
        { 
                
                $$ = $1;
                $$->next = $2;
        }
        ;

// a statement can be an expression statement, a compound statement, a
// IF statement, a WHILE statement, an assignment statement, a return statement,
// a read statement, or a write statement
Statement : Expression_Stmt 
        { 
                $$ = $1;
        }
        | Compound_Stmt 
        { 
                $$ = $1;
        }
        | Selection_Stmt 
        {
                $$ = $1;
        }
        | Iteration_Stmt 
        { 
                $$ = $1;
        }
        | Assignment_Stmt 
        {
                $$ = $1;
        }
        | Return_Stmt 
        {
                $$ = $1;
        }
        | Read_Stmt 
        { 
                $$ = $1;
        }
        | Write_Stmt 
        {
                $$ = $1; 
        }
        ;

// an expression statement can be an expression followed by a semicolon or
// just a semicolon
Expression_Stmt : Expression ';' 
        { 
                $$ = ASTCreateNode(A_EXPRSTMT);
                $$->s1 = $1;
        }
        | ';' 
        { 
                $$ = ASTCreateNode(A_EXPRSTMT);
                
        } /*empty followed by semicolon*/
        ;   

// if statement can be just an if statement or an if else statement
Selection_Stmt : T_IF '(' Expression ')' Statement
        {
                $$ = ASTCreateNode(A_IF);
                $$->s1 = $3;
                $$->s2 = ASTCreateNode(A_IFBODY);
                $$->s2->s1 = $5;
                
                
        }
        // if else statement. We use the s2 of the A_IF node to store another
        // statement and its s2 to store more statements
        | T_IF '(' Expression ')' Statement T_ELSE Statement /*else statement optional*/
        {
                $$ = ASTCreateNode(A_IF);
                $$->s1 = $3;
                $$->s2 = ASTCreateNode(A_IFBODY);
                $$->s2->s1 = $5;
                $$->s2->s2 = $7;
                
                
        }
        ;
// we are iterating over a statement
// s1 will be the expression and s2 will be the statement
Iteration_Stmt : T_WHILE '(' Expression ')' Statement
        {
                $$ = ASTCreateNode(A_WHILE);
                $$->s1 = $3;
                $$->s2 = $5;
        }
        ;
// we are reading into a variable
Read_Stmt : T_READ Var ';' 
        { 
                $$ = ASTCreateNode(A_READ);
                $$->s1 = $2;
        }
        ;
// We are returning a expression or nothing
// if we are returning an expression, s1 will be the expression 
// and passed up the tree
Return_Stmt : T_RETURN ';'
        { 
                $$ = ASTCreateNode(A_RETURN);
        }
        | T_RETURN Expression ';' /*expression optional*/
        { 
                $$ = ASTCreateNode(A_RETURN);
                $$->s1 = $2;
        }
        ;
// Here we are writing a string or an expression to the screen
// if we are writing an expression, s1 will be the expression and 
// passed up the tree
Write_Stmt : T_WRITE Expression ';' 
        { 
                $$ = ASTCreateNode(A_WRITE);
                $$->s1 = $2;
        }
        | T_WRITE T_STRING ';' 
        { 
                $$ = ASTCreateNode(A_WRITE); 
                $$->name = $2;
        }
        ;
// Here we are assigning a value to a variable
// s1 is the variable on the left side of the assignment
// s2 is the expression on the right side of the assignment
Assignment_Stmt : Var '=' Simple_Expression ';'
        { 
                $$ = ASTCreateNode(A_ASSIGN);
                $$->s1 = $1;
                $$->s2 = $3;
        }
        ;

// Here we are refrencing a variable that has already been declared
// it can either be a reference to a scalar or an array
Var : T_ID 
        {
                $$ = ASTCreateNode(A_VAR);
                $$->name = $1;
                $$->value = 0; // scalar
        }
        | T_ID '[' Expression ']' 
        {
                $$ = ASTCreateNode(A_VAR);
                $$->name = $1;
                $$->s1 = $3;
                $$->value = -1; // reference to array
        }
        ;
// pass up the expression tree
Expression : Simple_Expression 
        {
                $$ = $1;
        }
        ;
// pass up the expression tree
Simple_Expression : Additive_Expression 
        {
                $$ = $1; 
        }
        // This is a relational expression
        | Additive_Expression Relop Simple_Expression 
        {
                $$ = ASTCreateNode(A_EXPRESSION);
                $$->s1 = $1;
                $$->s2 = $3;
                $$->operator = $2;
        }
        ;
// Types of relational operators
Relop : T_LT
        {
                $$ = A_LT;
        }
        | T_LE
        { 
                $$ = A_LE;
        }
        | T_GT
        { 
                $$ = A_GT;
        }
        | T_GE
        { 
                $$ = A_GE;
        }
        | T_EQ
        { 
                $$ = A_EQ;
        }
        | T_NE
        { 
                $$ = A_NE;
        }
        | T_MOD
        { 
                $$ = A_MOD;
        }
        ;
// pass up the expression tree
Additive_Expression : Term 
        { 
                $$ = $1;
        }
        // This is an additive expression
        | Additive_Expression Addop Term /* changed to be left recurisve*/ 
        { 
                $$ = ASTCreateNode(A_EXPRESSION); 
                $$->s1 = $1;
                $$->s2 = $3; 
                $$->operator = $2;
        }
        ;
// Types of additive operators
Addop   : '-'
        {
                $$ = A_MINUS;
                
        }
        | '+' 
        {
                $$ = A_PLUS;
        }
        ;
// pass up the expression tree
Term    : Factor 
        {
                $$ = $1;
        }
        // This is a multiplicative or division expression
        | Term Multop Factor /* changed to be left recurisve*/ 
        {
                $$ = ASTCreateNode(A_EXPRESSION);
                $$->s1 = $1; 
                $$->s2 = $3;
                $$->operator = $2;
        }
        ;
// types of multiplicative operators
Multop  : '*' 
        {
                $$ = A_TIMES;
        }
        | '/'
        {
                $$ = A_DIVIDE;
        }
        ;

// factor can be an expression inside of parenthesis
Factor  : '(' Expression ')' 
        { 
                $$ = $2;
        }
        | T_NUM  // can be a number
        {
                $$ = ASTCreateNode(A_NUM);
                $$->value = $1;
        }
        | Var  // or a variable
        {
                $$ = $1;
        }
        | Call // or a function call
        {
                $$ = $1;
        }
        | '-' Factor // or a negative number
        {
                $$ = ASTCreateNode(A_EXPRESSION);
                $$->s1 = $2;
                $$->operator = A_UMINUS;
        }
        ;
// This is a function call
Call    : T_ID '(' Args ')'
        {
                $$ = ASTCreateNode(A_CALL);
                $$->name = $1;
                $$->s1 = $3;
        }
        ;

// function arguments can be empty or are passed up the tree
Args    : Arg_List 
        {
                $$ = $1;
                
        }
        // or there are no arguments
        | /*empty*/ 
        {
                $$ = NULL;
                
        }
        ;

        
// pass up the tree
Arg_List : Expression
        {
                $$ = $1;
        }
        // or there are more arguments that are next connected
        | Expression ',' Arg_List
        {
                $$ = ASTCreateNode(A_ARG);
                $$->s1 = $1;
                $$->next = $3;
        }
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
        printf("\nFinished Parsing\n\n\n");
        ASTprint(0, PROGRAM);
	
} // end main()
