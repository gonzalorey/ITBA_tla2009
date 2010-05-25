/* Grammar.h  */

#ifndef GRAMMAR_H_
#define GRAMMAR_H_

#include "LinkedList.h"


typedef struct {
	char *predecessor;
	char *successor; //String vacio significa lambda
} production_t;


typedef struct grammarCDT *grammar_t;

grammar_t newGrammar(char *name);

void GrammarAddNonTerminal(grammar_t grammar, char nonTerminal);

void GrammarAddTerminal(grammar_t grammar, char terminal);

void GrammarSetStarting(grammar_t grammar, char starting);

int GrammarIsLeftRegular(grammar_t grammar);

int GrammarIsRightRegular(grammar_t grammar);

int GrammarIsValid(grammar_t grammar);

void GrammarAddProduction(grammar_t grammar, production_t *production);

void FreeGrammar(grammar_t grammar);

void GrammarDump(grammar_t grammar);

char *GrammarGetName(grammar_t grammar);

char *GrammarGetNonTerminals(grammar_t grammar);

char *GrammarGetTerminals(grammar_t grammar);

char GrammarGetStarting(grammar_t grammar);

int GrammarContainsProduction(grammar_t grammar, production_t *production);

LinkedList_t GrammarGetProductions(grammar_t);
#endif /* GRAMMAR_H_ */
