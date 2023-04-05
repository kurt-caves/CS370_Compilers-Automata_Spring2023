# Kurt Lyell
# CS370
# Lab5 --makefile
# 03/01/2023
# 



all: lab5

lab5: lab5.l lab5.y
	lex lab5.l 
	yacc -d lab5.y
	gcc y.tab.c lex.yy.c -o lab5
	
	
run: lab5
	./lab5
clean:
	rm -f lab5

