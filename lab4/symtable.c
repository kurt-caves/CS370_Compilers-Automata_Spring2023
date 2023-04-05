/*
Kurt Lyell
CS 370 - Compilers
Lab4 - symtable.c
02/19/2023

This file implements a basic symbol table using the linked list data structure.
This file ties in with our YACC file. When YACC encounters a symbol it will use functions
from this file to insert, search and fetch addresses from the symbol table because of our grammar
rules and syntax directed symantic action that are defined in lab4.y. This file does nothing on its
own now, lab4.y does the driving.


*/



// include libraries
#include<stdio.h>
#include<malloc.h>
#include<string.h>
#include<stdlib.h>

// include the header file
#include "symtab.h"

// global vaiable to keep track of the size of the linked list
int size = 0;

// global variable for the head and tail of our linked list
struct SymbTab *first,*last;






/*

precondition:
    symbol is a string that contains the symbol to be inserted into the linked list
    address is an integer that contains the address of the symbol to be inserted into the linked list
postcondition:
    A new node is created and inserted into the linked list. The new node contains the symbol and address
    that was passed into the function. If the symbol already exists in the linked list then the user is
    notified that the symbol already exists in the linked list. 

    If the linked list is empty then the new node is set as the first and last node in the linked list.

    If the linked list is not empty then the new node is inserted at the end of the linked list.

*/
void Insert(char *symbol, int address) {

    // check if the symbol already exists in the symbol table
    int i;
    i = Search(symbol);
    if(i == 1 ) printf("\n\t Symbol already exists in the symbol table.\n");

    // if the symbol does not exist create a new node
    else {
        // create a new node
        struct SymbTab *p;
        // dynamically allocate memory for the new node based on the size of the struct
        // new node(p) points to the newly allocated memory
        p = malloc(sizeof(struct SymbTab));

        // copy the symbol into the new node
        p->symbol = strdup(symbol);

        // copy the address into the new node
        p->addr = address;

        // set the next pointer to null
        p->next = NULL;

        // check if the symbol linked list is empty
        if(size == 0) {
            // if the symbol linked list is empty set the first and last node to the new node
            first = p;
            last = p;
        }
        // if the symbol linked list is not empty
        else {
            // set the last node's next pointer to the new node
            last->next = p;
            // set the last node to the new node
            last = p;
        }
        // increment the size of the symbol linked list
        size++;
        
    }
    
} // end Insert()


/*
precondition:
    none

postcondition:
    linked list is traversed and each node is printed to the screen

*/
void Display() {

    // create a new linked list that is equal to our current linked list
    // this is done so that we can traverse the linked list without effecting the original linked list
    struct SymbTab *p;
    p = first;

    printf("\n\tSYMBOL\t\tADDRESS\n");

    // traverse the linked list
    for(int i = 0; i < size; i++) {
        // print the symbol and address of the current node
        printf("\t%s\t\t%d\n", p->symbol, p->addr);
        p = p->next;
    }


} // end Display()


/*
precondition:
    symbol is a string that contains the symbol to be searched for from the linked list.
    

postcondition:
    The linked list is traversed and if the symbol is found then a flag (1) is returned to the calling function.
    If the symbol is not found then a flag (0) is returned to the calling function.
*/
int Search(char *symbol) {
    
    
    if(size == 0) return 0; // if the linked list is empty return 0 (false)

    // create a new linked list that is equal to our current linked list
    // this is done so that we can traverse the linked list without effecting the original linked list
    struct SymbTab *p;
    p = first;
    

    // traverse the linked list
    for(int i = 0; i < size; i++) {
        if(strcmp(p->symbol, symbol) == 0) return 1;
        
        p = p->next;
    }

    return 0;
    
} // end Search()


/*
precondition:
    symbol is a string that contains the symbol to be deleted from the linked list.
postcondition:
    The linked list is traversed and if the symbol is found then the node containing the symbol is deleted.
    If the symbol is not found then the user is notified that the symbol does not exist in the linked list.
*/
void Delete(char *symbol) {
    
    // the main method has already checked to see if the symbol exists in the linked list
    // so we know its in there, all we have to do is traverse the linked list till we reach
    // the node that contains the symbol and delete it.
    struct SymbTab *p, *q;
    // p is a pointer to the current node, q is a pointer to the previous node
    p = first;
    q = NULL;

    // traverse the linked list
    // q is always one node behind p
    while(strcmp(p->symbol, symbol) != 0) {
        q = p;
        p = p->next;
    }

    // check if the node to be deleted is the first node in the linked list
    if(q == NULL) {
        first = p->next;
    }

    // check if the node to be deleted is the last node in the linked list
    else if(p == last) {
        last = q;
        last->next = NULL;
    }

    // if the node to be deleted is not the first or last node in the linked list
    // it must be somewhere in the middle of the linked list
    else{q->next = p->next;}

    // update the size of the linked list
    size--;
 
} // end Delete()


/*
precondition:
    symbol is a string that contains the symbol to be searched for from the linked list.
postcondition:
    The linked list is traversed and if the symbol is found then the address of the symbol is returned to the calling function.
    If the symbol is not found then 0 is returned to the calling function.
*/
int FetchAdd(char* symbol) {

    struct SymbTab *p;
    // check if the symbol exists in the linked list
    // if it is in the linked list then return the address of the symbol
    if(Search(symbol)) {
        while(p != NULL) {
            if(strcmp(p->symbol, symbol) == 0) return p->addr;
            p = p->next;
        }

    }

    // else return 0;
    return 0;
} // end FetchAdd()







