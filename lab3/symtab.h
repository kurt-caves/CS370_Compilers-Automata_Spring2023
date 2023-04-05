// Kurt Lyell
// CS 370
// Lab3 - symtab.h
// 02/06/2023
// Header file for symtable.c

#ifndef _SYM_TAB_H
#define _SYM_TAB_H

// modified Insert to take a char pointer and an int
void Insert(char *symbol, int address);

// modified search to take a char pointer
int Search(char *symbol );

void Display();

// modified delete to take a char pointer
void Delete(char *symbol);

// modified modify to take two char pointers and an int
void Modify(char *symbol, char *newSymbol, int address);

// added this function to modify the symbol
void ModifySymbol(char *symbol, char *newSymbol);

// added this function to modify the address
void ModifyAddress(char *symbol, int address);

// modified struct to take a char pointer
struct SymbTab {
    char* symbol;
    int addr;
    struct SymbTab *next;
};

#endif