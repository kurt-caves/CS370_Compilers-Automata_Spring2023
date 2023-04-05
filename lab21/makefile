# Kurt Lyell
# CS370
# Lab21 --makefile
# 01/26/2023
# This makefile will run LEX and compile the program and run it


all: lab21

lab21: lab21.l 
	lex lab21.l 
	gcc -o lab21 lex.yy.c
	
	
run: lab21
	./lab21
clean:
	rm -f lab21

