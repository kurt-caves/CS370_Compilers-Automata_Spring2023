/*
Kurt Lyell
CS 370 - Compilers
Lab3 - symtable.c
02/06/2023

This file implements a basic symbol table using the linked list data structure.
When the program is run, the user is prompted with a menu of options. The user can choose to 
insert a symbol, display the symbol table, delete a symbol, search for a symbol, and modify a symbol.

MALLOC QUESTION:
    malloc dynamically allocates memory for a variable on the heap during runtime and returns 
    a pointer to that memory location. This is helpful in this program because we are taking in
    user input for the symbol and address. We don't know how much memory we need to allocate before
    execution, so we use malloc to dynamically allocate the memory for struc SymbTab.


*/

// include libraries
#include<stdio.h>
#include<malloc.h>
#include<string.h>
#include<stdlib.h>

// include the header file
#include "symtab.h"

// global vaiable to keep track of the size of the linked list
int size=0;

// global variable for the head and tail of our linked list
struct SymbTab *first,*last;



/*
precondition: 
    none
postcondition: 
    The symbol table is updated. Based on user input(1-6) this method will insert a symbol,
    display the symbol, delete the symbol, search for a symbol, modify the symbol and lastly
    exit the program.

The entire main() method is changed from the original file.

*/
void main() {
    
    // int variables to keep track of user input, address, search result and modify choice
    int option,add,y,choice;
    
    // char arrays to keep track of user symbol input
    char symb[100];

    // char array to keep track of the new symbol in modify
    char newSymb[100];

    do {
        printf("\n\tSYMBOL TABLE IMPLEMENTATION\n");
        printf("\n\t1.INSERT\n\t2.DISPLAY\n\t3.DELETE\n\t4.SEARCH\n\t5.MODIFY\n\t6.END\n");
        printf("\n\tEnter your option : ");
        scanf("%d",&option);

        // switch statement to handle user input based of menu selection
        switch(option) {
            
            // insert a symbol
            case 1:
                printf("\n\tEnter the symbol to be inserted : ");
                scanf("%s",symb);
                printf("\n\tEnter the address : ");
                scanf("%d",&add);
                Insert(symb, add);
                break;
            
            // display the symbol table
            case 2:
                Display();
                break;

            // delete a symbol
            case 3:
                printf("\n\tEnter the symbol to be deleted : ");
                scanf("%s",symb);
                // search for the symbol
                y = Search(symb);
                // if the symbol is found, delete it
                if(y == 1)
                    Delete(symb);
                // else print that the symbol is not in the table
                else
                    printf("\n\tThe symbol is not present in the symbol table\n");
                break;

            // search for a symbol
            case 4:
                printf("\n\tEnter the symbol to be searched : ");
                scanf("%s",symb);
                // search for the symbol
                y = Search(symb);
                printf("\n\tSearch Result:");
                // if the symbol is found, print that it is in the table
                if(y == 1)
                    printf("\n\tThe symbol is present in the symbol table\n");
                // else print that the symbol is not in the table
                else
                    printf("\n\tThe symbol is not present in the symbol table\n");
                break;
            // modify a symbol or address or both
            case 5:
                printf("\n\tWhat do you want to modify?\n");
                printf("\n\t1.Only the symbol\n\t2.Only the address\n\t3.Both the symbol and address\n");
                printf("\tEnter your choice : ");
                scanf("%d",&choice);

                // nested switch statement to handle user input for modify()
                switch (choice) {
                    case 1:
                        printf("\n\tEnter the symbol to be modified : ");
                        scanf("%s",symb);
                        // search for the symbol
                        y = Search(symb);
                        // if the symbol is found, modify it
                        if(y == 1) {
                            printf("\n\tEnter the new symbol : ");
                            scanf("%s",newSymb);
                            ModifySymbol(symb, newSymb);
                            printf("\n\t After Modification : ");
                            Display();
                        }
                        // else print that the symbol is not in the table
                        else
                            printf("\n\tThe symbol is not present in the symbol table\n");
                        break;

                    // modify the address
                    case 2:
                        printf("\n\tEnter the symbol whose address is to be modified : ");
                        scanf("%s",symb);
                        printf("\n\tEnter the new address : ");
                        scanf("%d",&add);
                        // search for the symbol
                        y = Search(symb);
                        // if the symbol is found, modify it's address
                        if(y == 1) {
                            ModifyAddress(symb, add);
                            printf("\n\t After Modification : ");
                            Display();
                        }
                        // else print that the symbol is not in the table
                        else
                            printf("\n\tThe symbol is not present in the symbol table\n");
                        break;
                    
                    // modify both the symbol and address
                    case 3:
                        printf("\n\tEnter the symbol to be modified : ");
                        scanf("%s",symb);
                        // search for the symbol
                        y = Search(symb);
                        // if the symbol is found, modify it and its address
                        if(y == 1) {
                            printf("\n\tEnter the new address : ");
                            scanf("%d",&add);
                            printf("\n\tEnter the new symbol : ");
                            scanf("%s",newSymb);
                            Modify(symb, newSymb, add);
                            printf("\n\t After Modification : ");
                            Display();
                        }
                        // else print that the symbol is not in the table
                        else
                            printf("\n\tThe symbol is not present in the symbol table\n");
                        break;
                }
                break;

            // exit the program
            case 6:
                exit(0);
        }
    }
    while(option<6);

}  /* end of main */


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
    symbol is a string that contains the symbol to be modified in the linked list symbol table.
    newSymbol is a string that contains the new symbol to be inserted inplace of the old symbol.
    address is an integer that contains the address of the symbol to be inserted into the linked list
    
postcondition:
    The linked list is traversed, the exisiting node containing the user defined symbol is deleted
    and a new node is created with the new symbol and address and placed into the same position
    in the linked list as the old node.
*/
void Modify(char *symbol, char *newSymbol, int address){

    // the main method has already checked to see if the symbol exists in the linked list
    // so we know its in there, all we have to do is traverse the linked list till we reach it

    // create a new linked list data structure and set p to point to the head
    struct SymbTab *p;
    p = first;
    
    // traverse the linked list
    while(strcmp(p->symbol, symbol) != 0) {
        
        p = p->next;
    }

    // p is at the node that contains the symbol to be modified
    // replace the old symbol and address with the new symbol and address
    p->symbol = strdup(newSymbol);
    p->addr = address;

} // end Modify()


/*
precondition:
    symbol is a string that contains the symbol to be modified in the linked list symbol table.
    newSymbol is a string that contains the new symbol to be inserted inplace of the old symbol.
    
postcondition:
    The linked list is traversed, the exisiting node containing the user defined symbol is deleted
    and a new node is created with the new symbol and placed into the same position in the linked list 
    as the old node.
*/
void ModifySymbol(char *symbol, char *newSymbol){

     // the main method has already checked to see if the symbol exists in the linked list
    // so we know its in there, all we have to do is traverse the linked list till we reach it

     // create a new linked list data structure and set p to point to the head
    struct SymbTab *p;
    p = first;
    
    // traverse the linked list
    while(strcmp(p->symbol, symbol) != 0) {
        
        p = p->next;
    }

    // p is at the node that contains the symbol to be modified
    // replace the old symbol with the new symbol
    p->symbol = strdup(newSymbol);

} // end ModifySymbol()


/*
precondition:
    symbol is a string that contains the symbol where the address is to be modified.
    address is an integer that contains the address of the symbol to be inserted into the linked list
    
postcondition:
    The linked list is traversed, the node with the user defined symbol is located
    and the address of the node is modified to the new address.
*/
void ModifyAddress(char *symbol, int address) {

     // the main method has already checked to see if the symbol exists in the linked list
    // so we know its in there, all we have to do is traverse the linked list till we reach it

     // create a new linked list data structure and set p to point to the head
    struct SymbTab *p;
    p = first;
    
    // traverse the linked list
    while(strcmp(p->symbol, symbol) != 0) {
        
        p = p->next;
    }

    // p is at the node that contains the symbol where the address is to be modified
    // replace the old address with the new address
    p->addr = address;

} // end ModifyAddress()








