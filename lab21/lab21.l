%{ /* Header block for LEX, allows for comments */

/*
Kurt Lyell
CS 370 - Compilers
Lab21 - lab21.l
01/26/2023

This file uses LEX and C. This file parses supplied files by the user.
The purpose of this file is to count new lines, print possible lines
of code, and nested comments with their line number.
*/
  

int comment = 0;
int debug = 1;  /* set debug to 1*/
int newline = 1;  /*added newline to keep track of newlines*/
%}

%%


"/*"	{ 
        /* here if LEX sees the start of a comment and debug = 1 it sets comment = 1
        if no ending slash for a comment is seen then stderr is printed along
        with its line number
        Added newline variable in fprintf */
        if (comment && debug) fprintf(stderr,
          " >>>>>>>> line %d: Possible Nested comment <<<<<<<<<<\n", newline);
        comment = 1;
	    }

"*/"	{
        /* here if LEX sees the end of a comment and comment = 0 then the text
        is printed and comment is set back to 0*/
          if (!comment) printf("%s",yytext); /*print out if it is not in a comment */
  	  comment = 0;
	    }
.     { 
        /* here "." stands for any character but new line. So if LEX sees
        any character other than new line and comment = 0 then the text is printed*/
        if (!comment) printf("%s",yytext);
      }
\n  {
      /*I added this. here when a new line is seen a newline is printed
      and newline the variable is incremented to keep track of line numbers*/
      printf("\n");
      newline++;
    }

%%

int yywrap(void)
{ 
  return 1;
}

/*added int infront of main()*/
int main()
{
  yylex();
  
}

