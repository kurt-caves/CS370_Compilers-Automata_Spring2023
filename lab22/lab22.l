/* 

Kurt Lyell
CS 370 - Compilers
Lab22 - lab22.l
01/16/2023

This file is used to tell LEX to look for and pass tokens to YACC involving math operations and possible variables.
Two formal tokens that are passed to YACC are the INTEGER and VARIABLE tokens.


*/
%{

int mydebug; /*removed the initialization so this could be set from the terminal 01/16/23*/
#include "y.tab.h"
%}


%%

[a-z]		{if (mydebug) fprintf(stderr,"Letter found\n"); 
                       yylval=*yytext-'a'; return(VARIABLE);}
[0-9][0-9]*	{if (mydebug) fprintf(stderr,"Digit found\n"); 
                       yylval=atoi((const char *)yytext); return(INTEGER);}
[ \t]		{if (mydebug) fprintf(stderr,"Whitespace found\n");}
[=\-+*/%&()|] 	{ if (mydebug) fprintf(stderr,"return a token %c\n",*yytext); /*added parentheses 1/16/2023*/
                       return (*yytext);}
\n 		{ if (mydebug) fprintf(stderr,"cariage return %c\n",*yytext); 
                       return (*yytext);}

%%

int yywrap(void)
{ return 1;}


