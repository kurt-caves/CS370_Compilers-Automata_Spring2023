# Kurt Lyell
# CS370
# Lab7 --makefile
# 03/30/2023
# Make file for lab6. Added ast.c and ast.h to the makefile



all: lab7

lab7: lab7.l lab7.y ast.h ast.c symtable.h symtable.c
	lex lab7.l 
	yacc -d lab7.y
	gcc y.tab.c lex.yy.c ast.c symtable.c -o lab7
	
	
run: lab7
	./lab7
clean:
	rm -f lab7

