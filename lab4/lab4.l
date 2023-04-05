/* 

Kurt Lyell
CS 370 - Compilers
Lab4 - lab4.l
02/19/2023

This file is used to tell LEX to look for and pass tokens to YACC involving math operations and possible variables.
Two formal tokens that are passed to YACC are the INTEGER and VARIABLE tokens.


*/
%{

int mydebug; /*removed the initialization so this could be set from the terminal 01/16/23*/
int linenum = 1; /* Used to keep track of lines for error output*/
#include "y.tab.h"
%}


%%

"int"	{ /*added for declaring int variables, we look for "int" and return "T_INT" to YACC 02/19/23*/
            if (mydebug) fprintf(stderr,"int found\n"); 
            return(T_INT);
        }

[a-zA-Z][a-zA-Z0-9_]* { /*variables can now be more complex 02/19/23*/
            if (mydebug) fprintf(stderr,"Letter found\n"); 
            yylval.string=strdup(yytext); 
            return(VARIABLE);
        }

[0-9][0-9]* {
            if (mydebug) fprintf(stderr,"Digit found\n"); 
            yylval.value=atoi((const char *)yytext); 
            return(INTEGER);
        }
[ \t] {
            if (mydebug) fprintf(stderr,"Whitespace found\n");
        }
[;=\-+*/%&()|]  { /*added new token ';' for the lab 02/19/23*/
            if (mydebug) fprintf(stderr,"return a token %c\n",*yytext); /*added parentheses 1/16/2023*/
            return (*yytext);
        }
\n      { /*added linenum for counting lines 02/19/23*/
            if (mydebug) fprintf(stderr,"cariage return %c\n",*yytext);
            linenum++;
            return (*yytext);
         }

%%

int yywrap(void)
{ return 1;}


