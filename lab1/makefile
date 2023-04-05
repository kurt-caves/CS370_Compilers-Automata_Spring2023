# Kurt Lyell
# CS370
# Lab1 --makefile
# 01/10/2023
# This makefile will run LEX and compile the program and run it


all: lab1

lab1: lab1.l 
	lex lab1.l 
	gcc -o lab1 lex.yy.c
	
	
run: lab1
	./lab1
clean:
	rm -f lab1

