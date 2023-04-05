%{ /* Header block for LEX, allows for comments */
 
/*
Kurt Lyell
CS 370 - Compilers
Lab1 --lab1.l
01/20/2023

This file uses LEX and C. The purpose of this file is to parse supplied files
by the user. It has an array called 'lgths' used to store number of words per line
and count is used to keep track of the number of numbers. When this file is compiled 
and run against a file with words and numbers 

*/

int lgths[100]; /* keeps track of number of words per line, added "int" */

/*Added global variable count*/
int count = 0; /* keeps track of total number of numbers */
%} /*End header block for LEX*/

/*Here we are using regular expressions "[]" used for one character, "a-ZA-Z" used
for lower and uppercase letters, "+" used for one or more. This regular expressions
is used for pattern matching.

lgths[yyleng]++ is used to store the length of the matched string from the
regular expression.

"[0-9]+ is a regular expression numbers 0-9 and one or more of them. The
varibale count is used to keep track of the number of numbers

"." is used for any character except new line, but does nothing here.
"\n" is used for new line, but does nothing here.*/
%%
[a-zA-Z]+	{lgths[yyleng]++;}
[0-9]+		{count++;/*added count to count lines 01/10/23*/}
.	|
\n			{;/*match any character or new line and do no-op(consume)*/}
%%

/*Added int to the front of yywrap() and added the printf statement for count

The purpose of yywrap() in this file is that it is called by LEX when input is 
exhausted, we return(1) because we want it to stop. 

The function uses a for loop that starts at 1, i is printed along with the length
of the word and the number of words per line, along with the count of numbers.
*/
int yywrap()
{
	int i;
	printf("Length	  No. words\n");
	for (i=1; i<100; i++) {
		if (lgths[i] > 0) {
			printf("%5d%10d\n",i,lgths[i]);
		}
	}
     printf("Count of times a number occurs: %d\n", count);
	return(1);
}

/*Added int to the front of main()

The purpose of main() is to call yylex() which is the main entry point for LEX.

*/
int main()
{  yylex();

}
