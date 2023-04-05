# Kurt Lyell
# CS370
# Lab6 --makefile
# 03/29/2023
# Make file for lab6. Added ast.c and ast.h to the makefile



all: lab6

lab6: lab6.l lab6.y ast.h ast.c
	lex lab6.l 
	yacc -d lab6.y
	gcc y.tab.c lex.yy.c ast.c -o lab6
	
	
run: lab6
	./lab5
clean:
	rm -f lab6

