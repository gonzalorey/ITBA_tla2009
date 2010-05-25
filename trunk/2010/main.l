/*++++++++++++++++++++++++++++++++++ Seccion de definiciones ++++++++++++++++++++++++++++++++++++*/
%{
#include <stdio.h> 
#include "String.h"
#include "Grammar.h"
#include "LinkedList.h"

grammar_t currGrammar;
LinkedList_t grammarList;
string_t  currPred;

void printLetters(char *str);
void printProductions(LinkedList_t prods);
void printGrammarType(grammar_t grammar);
void freeProds(LinkedList_t prods);


%}
/* Nombre de la gramatica */
GRAMMAR_NAME	[a-zA-Z0-9]+

/* Simbolos No Terminales */
SNT				[A-Z]		
SNTs			{SNT}(,{SNT})*

/* Simbolos Terminales */
ST				[a-z]		
STs				{ST}(,{ST})*

/* Simbolo Inicial */
SI				[A-Z]

/* Producciones */

PRED			({SNT}|{ST})+
SUCC			(({SNT}|{ST})+|\\)
SUCCs			({SUCC}(\|{SUCC})*)
PROD			{PRED}"->"{SUCCs}
PRODs			{PROD}(,{PROD})*

/* Grupos */
CLOSING_PRODUCTION ","
OPENING_GRAMMAR	"("
CLOSING_GRAMMAR	")"
OPEN_GROUP		"{"
CLOSE_GROUP		"}"

/* Estados */
%s		IN_GRAMMAR
%s		IN_SNTs
%s		IN_STs
%s		IN_SI
%s		IN_PRODs
%s		IN_PROD

/*+++++++++++++++++++++++++++++++++ Seccion de reglas /yylex ++++++++++++++++++++++++++++++++++++*/
%%

<INITIAL>{GRAMMAR_NAME}/={OPENING_GRAMMAR}"{"{SNTs}"},{"{STs}"},"{SI}",{"{PRODs}"}"{CLOSING_GRAMMAR} {
	BEGIN(IN_GRAMMAR);
	
	
	currGrammar = newGrammar(yytext);
	
	printf("GRAMMAR_NAME:%s\n", yytext);
}

<IN_GRAMMAR>{OPEN_GROUP}/{SNTs} {
	BEGIN(IN_SNTs);
}

<IN_SNTs>{SNT} {
	printf("SNT:%s\n",yytext);
	
	GrammarAddNonTerminal(currGrammar, yytext[0]);
}

<IN_SNTs>{CLOSE_GROUP} {
	BEGIN(IN_STs);
}

<IN_STs>{ST} {

	GrammarAddTerminal(currGrammar, yytext[0]);
	printf("ST:%s\n",yytext);
}

<IN_STs>{CLOSE_GROUP} {
	BEGIN(IN_SI);
}


<IN_SI>{SI} {
	BEGIN(IN_PRODs);
	GrammarSetStarting(currGrammar, yytext[0]);
	printf("SI:%s\n", yytext);
	
}

<IN_PRODs>{PRED}/"->"{SUCCs} {

	printf("PRED: %s\n", yytext);
	BEGIN(IN_PROD);
	
	if(currPred == NULL)
		FreeString(currPred);
	currPred = newString(yytext);
}

<IN_PROD>{SUCC}	{
	
	printf("SUCC: %s\n", yytext);
	production_t *prod = malloc(sizeof(production_t));
	
	prod->predecessor = newString(currPred);
	prod->successor = newString((yytext[0] == '\\')? "": yytext);
	
	
	GrammarAddProduction(currGrammar, prod);
}

<IN_PROD>{CLOSING_PRODUCTION}	{
	BEGIN(IN_PRODs);
	FreeString(currPred);
}

<IN_PROD>{CLOSING_GRAMMAR} {
	BEGIN(INITIAL);
	
	LinkedListInsert(grammarList, currGrammar);
	
	printf("OK GRAMMAR\n");
}

.		;
%%

/*+++++++++ Seccion de funciones de usuario ++++++++++ */
int
main(void)
{
	grammarList = newLinkedList();
	yylex();
	
	LinkedListBeginIterator(grammarList);
	
	
	while(LinkedListHasNext(grammarList)){
		grammar_t grammar = LinkedListGetNext(grammarList);
		printf("****** Gramatica: %s ******\n", GrammarGetName(grammar));
		
		printf("Símbolos no terminales: ");
		
		printLetters(GrammarGetNonTerminals(grammar));
						
		putchar('\n');
		
		
		printf("Símbolos terminales: ");

		printLetters(GrammarGetTerminals(grammar));
		
		putchar('\n');
		
		
		printf("Símbolo incial: %c\n", GrammarGetStarting(grammar));
		
		printf("Producciones: ");

		printProductions(GrammarGetProductions(grammar));

		putchar('\n');

		printGrammarType(grammar);
		
		
		freeProds(GrammarGetProductions(grammar));
		FreeGrammar(grammar);

	}
	
	return 0;
}


void printLetters(char *str){

	char *sep = "";

	while(*str != '\0'){
		printf("%s%c", sep, *str);
		sep = ", ";
		str++;
	}
}


void printProductions(LinkedList_t prods){
	LinkedListBeginIterator(prods);
	
	char *sep = "";
	
	while(LinkedListHasNext(prods)){
		production_t *prod = LinkedListGetNext(prods);
		
		printf("%s%s->%s", sep, prod->predecessor, ((strlen(prod->successor) == 0)? "\\": prod->successor));	
		sep=", ";
		
	}
}


void freeProds(LinkedList_t prods) {
	LinkedListBeginIterator(prods);
	
	
	while(LinkedListHasNext(prods)){
		production_t *prod = LinkedListGetNext(prods);
	
		FreeString(prod->predecessor);
		FreeString(prod->successor);
		free(prod);
	}
}

void printGrammarType(grammar_t grammar){
	if(GrammarIsValid(grammar)){
		printf("La gramática es válida\n");
		int regular = 0;
		if(GrammarIsLeftRegular(grammar)){
			regular = 1;
			printf("La gramática es regular izquierda\n");
		} 
		if (GrammarIsRightRegular(grammar)) {
			regular = 1;
			printf("La gramática es regular derecha\n");
		} 
		if (!regular){
			printf("La gramática no es regular\n");
		}
		} else
		{
			printf("La gramática no es válida\n");
	}
}
