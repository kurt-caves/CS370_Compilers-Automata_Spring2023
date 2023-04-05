# Kurt Lyell
# CS370
# Lab4 --makefile
# 02/19/2023
# This makefile will run LEX, YACC and compile our symboltable.c and run it



all: lab4

lab4: lab4.l lab4.y symtab.h symtable.c
	lex lab4.l 
	yacc -d lab4.y
	gcc symtable.c y.tab.c lex.yy.c -o lab4
	
	
run: lab4
	./lab4
clean:
	rm -f lab4

