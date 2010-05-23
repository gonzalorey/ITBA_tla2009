/*++++++++++++++++++++++++++++++++++ Seccion de definiciones ++++++++++++++++++++++++++++++++++++*/
%{
#include <stdio.h> 
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
PROD			({SNT}|{ST})+"->"(({SNT}|{ST})+|\\)
PRODs			{PROD}(,{PROD})*

/* Grupos */
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

/*+++++++++++++++++++++++++++++++++ Seccion de reglas /yylex ++++++++++++++++++++++++++++++++++++*/
%%

<INITIAL>{GRAMMAR_NAME}/={OPENING_GRAMMAR}"{"{SNTs}"},{"{STs}"},"{SI}",{"{PRODs}"}"{CLOSING_GRAMMAR} {
	BEGIN(IN_GRAMMAR);
	printf("GRAMMAR_NAME:%s\n", yytext);
}

<IN_GRAMMAR>{OPEN_GROUP}/{SNTs} {
	BEGIN(IN_SNTs);
}

<IN_SNTs>{SNT} {
	printf("SNT:%s\n",yytext);
}

<IN_SNTs>{CLOSE_GROUP} {
	BEGIN(IN_STs);
}

<IN_STs>{ST} {
	printf("ST:%s\n",yytext);
}

<IN_STs>{CLOSE_GROUP} {
	BEGIN(IN_SI);
}


<IN_SI>{SI} {
	BEGIN(IN_PRODs);
	printf("SI:%s\n", yytext);
}

<IN_PRODs>{PROD} {
	printf("PROD:%s\n",yytext);
}

<IN_PRODs>{CLOSING_GRAMMAR} {
	BEGIN(INITIAL);
	printf("OK GRAMMAR\n");
}

.		;
%%

/*++++++++++++++++++++++++++++++ Seccion de funciones de usuario ++++++++++++++++++++++++++++++++*/
int
main(void)
{
	yylex();
}