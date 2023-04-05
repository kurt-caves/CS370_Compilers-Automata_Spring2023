%{

/*
Kurt Lyell
CS 370 - Compilers
Lab5 - lab5.y
03/01/2023 

This Lex file is used to parse the input file and return the tokens to the parser(YACC). Added tokens
for input that looks like basic C code, math operators, relational operators, variables, numbers and comments.
Also had to consume tabs and spaces to prevent weird spacing in the output.

*/  

#include "y.tab.h"

int mydebug;
int linenum = 1;

%}

%%

"int"       { return(T_INT);}
"void"      { return(T_VOID);}
"if"        { return(T_IF);}
"else"      { return(T_ELSE);}
"while"     { return(T_WHILE);}
"return"    { return(T_RETURN);}
"read"      { return(T_READ);}
"write"     { return(T_WRITE);}
"<"         { return(T_LT);}
"<="        { return(T_LE);}
">"         { return(T_GT);}
">="        { return(T_GE);}
"=="        { return(T_EQ);}
"!="        { return(T_NE);}




[0-9][0-9]* {
            if (mydebug) fprintf(stderr,"Digit found\n"); 
            yylval.value=atoi((const char *)yytext); 
            return(T_NUM);
        }

[a-zA-Z][a-zA-Z0-9_]* { 
            if (mydebug) fprintf(stderr,"Letter found\n"); 
            yylval.string=strdup(yytext); 
            return(T_ID); /*this also covers letter*/
            }
[;=\-+*/%()|{}!&,\[\]]  { 
            if (mydebug) fprintf(stderr,"Relational operator or grammar structure found %c\n",*yytext); 
            return (*yytext);
        }
\n      {
            linenum++;
            if(mydebug) fprintf(stderr,"New line found");
        }
\t     {    /*added to consume tabs and prevent weird spaced output*/
            if(mydebug) fprintf(stderr,"Tab found");
        }
[ ]      {  /*added to consume spaces and prevent weird spaced output*/
            if(mydebug) fprintf(stderr,"Space found");
        }

\/\/.*  { /*added to consume comments*/
            if (mydebug) fprintf(stderr,"Comment found\n"); 
            
        }

\".*\"  { /*added to return strings*/
            if (mydebug) fprintf(stderr,"String found\n"); 
            yylval.string=strdup(yytext); 
            return(T_STRING);
        }
%%

int yywrap(void)
{ return 1;}