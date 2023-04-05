// Kurt Lyell
// CS 370
// Lab4 - symtab.h
// 02/19/2023
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

// added 02/19/23
int FetchAdd(char* symbol);

// modified struct to take a char pointer
struct SymbTab {
    char* symbol;
    int addr;
    struct SymbTab *next;
};

#endif