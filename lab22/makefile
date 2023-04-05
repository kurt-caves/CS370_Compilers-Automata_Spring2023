# Kurt Lyell
# CS370
# Lab22 --makefile
# 01/26/2023
# This makefile will run LEX and compile the program and run it

# Q1
#	YACC creates files y.tab.h & y.tab.c

# Q2
#	LEX creates the file lex.yy.c

# Q3
#	We do not directly compile LEX output because the output of LEX is tokens that represent symbols of the input source code. These
#	tokens are created during the lexer phase (LEX) and passed onto YACC which defines our grammar rules and makes use
# 	syntax directed semantic action.


all: lab22

lab22: lab22.l lab22.y
	lex lab22.l 
	yacc -d lab22.y
	gcc y.tab.c lex.yy.c -o lab22
	
	
run: lab22
	./lab22
clean:
	rm -f lab22

