/* Grammar.c */

#include "LinkedList.h"
#include "String.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define IS_UPPER(x)		(('A' <= x && x <= 'Z'))
#define IS_LOWER(x)		(('a' <= x && x <= 'z'))


struct grammarCDT {
	char		*name;
	char		*snts;
	char		*sts;
	char		si;
	LinkedList_t prods;
};

#include "Grammar.h"

grammar_t newGrammar(char *name){

	grammar_t grammar;

	if((grammar = malloc(sizeof(struct grammarCDT))) == NULL)
		return NULL;

	grammar->name = newString(name);
	grammar->prods = newLinkedList();
	grammar->sts = newString("");
	grammar->snts = newString("");
	grammar->si = '\\';


	return grammar;
}


void FreeGrammar(grammar_t grammar){

	FreeString(grammar->name);
	FreeString(grammar->sts);
	FreeString(grammar->snts);

	FreeLinkedList(grammar->prods);


	free(grammar);


}

void GrammarAddNonTerminal(grammar_t grammar, char nonTerminal){

	if(IS_UPPER(nonTerminal) && !StringContainsChar(grammar->snts, nonTerminal)){
		grammar->snts = StringAppendChar(&grammar->snts, nonTerminal);
	}

}


void GrammarAddTerminal(grammar_t grammar,char terminal){

	if(IS_LOWER(terminal) && !StringContainsChar(grammar->sts, terminal)){
		grammar->sts = StringAppendChar(&grammar->sts, terminal);
	}
}

void GrammarSetStarting(grammar_t grammar, char starting){
	if(IS_UPPER(starting))
		grammar->si = starting;
}

int GrammarIsValid(grammar_t grammar){

	if(!StringContainsChar(grammar->snts, grammar->si)){
		return 0;
	}

	LinkedListBeginIterator(grammar->prods);


	while(LinkedListHasNext(grammar->prods)){
		production_t *prod = LinkedListGetNext(grammar->prods);

		int predecesorLenght = strlen(prod->predecessor);
		int succesorLenght = strlen(prod->successor);
		int i;


		//El predecesor debe tener al menos un símbolo
		if(predecesorLenght < 1)
			return 0;

		//Los símbolos del sucesor deben estar en los símbolos
		//terminales o en los no terminales.

		for(i  = 0 ; i < predecesorLenght ; i++){
			if(!(StringContainsChar(grammar->snts, prod->predecessor[i])
					|| StringContainsChar(grammar->sts, prod->predecessor[i])))
			{
				return 0;
			}
		}


		//Los símbolos del predecesro deben estar en los símbolos
		//terminales o en los no terminales.

		for(i  = 0 ; i < succesorLenght ; i++){
			if(!(StringContainsChar(grammar->snts, prod->successor[i])
					|| StringContainsChar(grammar->sts, prod->successor[i])))
			{
				return 0;
			}
		}


	}


	return 1;
}


int GrammarIsRightRegular(grammar_t grammar){


	if(!GrammarIsValid(grammar))
		return 0;


	LinkedListBeginIterator(grammar->prods);


	while(LinkedListHasNext(grammar->prods)){
		production_t *prod = LinkedListGetNext(grammar->prods);

		if(strlen(prod->predecessor) != 1
				|| !StringContainsChar(grammar->snts, prod->predecessor[0])){
			return 0;
		}

		if(strlen(prod->successor) > 2){
			return 0;
		}

		//A->a
		if(strlen(prod->successor) == 1
				&& !StringContainsChar(grammar->sts, prod->successor[0]))
			return 0;


		//A->aB
		if(strlen(prod->successor) == 2
				&& (!StringContainsChar(grammar->sts, prod->successor[0])
				|| !StringContainsChar(grammar->snts, prod->successor[1]))){
			return 0;
		}


	}
		//A->/

		return 1;

}


int GrammarIsLeftRegular(grammar_t grammar){


	if(!GrammarIsValid(grammar))
		return 0;


	LinkedListBeginIterator(grammar->prods);


	while(LinkedListHasNext(grammar->prods)){
		production_t *prod = LinkedListGetNext(grammar->prods);

		if(strlen(prod->predecessor) != 1
				|| !StringContainsChar(grammar->snts, prod->predecessor[0])){
			return 0;
		}

		if(strlen(prod->successor) > 2){
			return 0;
		}

		//A->a
		if(strlen(prod->successor) == 1
				&& !StringContainsChar(grammar->sts, prod->successor[0]))
			return 0;


		//A->Ba
		if(strlen(prod->successor) == 2
				&& (!StringContainsChar(grammar->sts, prod->successor[1])
				|| !StringContainsChar(grammar->snts, prod->successor[0]))){
			return 0;
		}
	}

	//A->/
		return 1;
}


void GrammarDump(grammar_t grammar){

	int i;
	int nts = StringLength(grammar->snts);
	int ts = StringLength(grammar->sts);
	char *separator;


	printf("%s=({", grammar->name);

	separator = "";

	for(i = 0 ; i < nts ; i++){
		printf("%s%c", separator, grammar->snts[i]);
		separator = ", ";
	}

	printf("}, {");

	separator = "";

	for(i = 0 ; i < ts ; i++){
		printf("%s%c", separator, grammar->sts[i]);
		separator = ", ";
	}

	printf("}, %c, {", grammar->si);


	LinkedListBeginIterator(grammar->prods);

	separator = "";
	while(LinkedListHasNext(grammar->prods)){
		production_t *prod = LinkedListGetNext(grammar->prods);

		printf("%s%s->%s", separator, prod->predecessor, ((strlen(prod->successor) == 0)? "\\":prod->successor));
		separator = ", ";
	}

	printf("})\n");
}

void GrammarAddProduction(grammar_t grammar, production_t *production){
	if(!GrammarContainsProduction(grammar, production))
		LinkedListInsert(grammar->prods, production);
}

int GrammarContainsProduction(grammar_t grammar, production_t *production){
	LinkedListBeginIterator(grammar->prods);
	
	while(LinkedListHasNext(grammar->prods)){
		production_t *prod = LinkedListGetNext(grammar->prods);
		
		if(strcmp(production->predecessor, prod->predecessor) == 0
		 && strcmp(production->successor, prod->successor) == 0){
			return 1;
		}
	}
	
	return 0;
	
}


char *GrammarGetName(grammar_t grammar){
	return grammar->name;
}

char *GrammarGetNonTerminals(grammar_t grammar){
	return grammar->snts;
}

char *GrammarGetTerminals(grammar_t grammar){
	return grammar->sts;
}

char GrammarGetStarting(grammar_t grammar){
	return grammar->si;
}

LinkedList_t GrammarGetProductions(grammar_t grammar){
	return grammar->prods;
}
