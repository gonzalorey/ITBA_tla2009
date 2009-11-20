%{
#include <stdio.h>
#include "match_functions.h"
#include <string.h>

void printEntry(char * lexeme, char * token);

int elinkNum = 1;
int refNum = 0;
int stateCaller;

typedef enum{ITALIC, BOLD, I_LINK_OPEN, I_LINK_SEPARATOR, I_LINK_CLOSE, E_LINK_OPEN,
	E_LINK_SEPARATOR, E_LINK_CLOSE, HTTP, REDIRECT, HEAD1, HEAD2, HEAD3,
	HEAD4, HEAD5, REF_OPEN, REF_SEPARATOR, REF_CLOSE, REF_LIST, BULLET_LIST_ITEM,
	NUMBERED_LIST_ITEM, INDENTING_ITEM, IMAGE_OPEN, IMAGE_CLOSE, IMAGE_SEPARATOR,
	IMAGE_ALT, TEXT} tokens;

//TEXT + 1 porque TEXT es el ultimo elemento del enum de tokens.
#define CANT_TOKEN (TEXT+1)

//vector con la cantidad de apariciones de cada lexema.
char * tokenName[CANT_TOKEN] = {"''", "'''", "[[", "|", "]]",
	"[", " ", "]", "http://", "#REDIRECT", "==", "===", "====",
	"=====", "======", "REF_OPEN", "REF_SEPARATOR", "REF_CLOSE", "REF_LIST", "BULLET_LIST_ITEM",
	"NUMBERED_LIST_ITEM", "INDENTING_ITEM", "IMAGE_OPEN", "IMAGE_CLOSE", "IMAGE_SEPARATOR",
	"IMAGE_ALT", "TEXT"};
int lexemesCant[CANT_TOKEN];

char str[MAX_LENGTH];
char str2[MAX_LENGTH];

typedef struct{
	char refName[REF_CANT];
	char link[MAX_LENGTH];
	char linkName[MAX_LENGTH];
	char explanation[MAX_LENGTH*3];
	int timesRef;	//cantidad de referencias que se hicieron
}refElem;

boolean inParagraph = TRUE;

refElem references[REF_CANT];
tList list;

%}

%x ELINK
%x ELINKNAME
%x ILINK
%x ILINKPIPE
%x REDIREC
%x REFCREATE
%x INDENT
%x BULLET
%x NUMBERED
%%

^:							{BEGIN(INDENT);lexemesCant[INDENTING_ITEM]++;}
<INDENT>:{1,20}				{lexemesCant[INDENTING_ITEM]++; printEntry(yytext, tokenName[INDENTING_ITEM]);}												
<INDENT>[^:\"\n"]+			{}
<INDENT>"\n\n"				{BEGIN(0);}
														
								
^"*"						{BEGIN(BULLET);lexemesCant[BULLET_LIST_ITEM]++;}									
<BULLET>"*"{1,20}			{lexemesCant[BULLET_LIST_ITEM]++; printEntry(yytext, tokenName[BULLET_LIST_ITEM]);}												
<BULLET>[^*\"\n"]+			{}														
<BULLET>"\n\n"				{BEGIN(0);}
														
		
^"#"						{BEGIN(NUMBERED);lexemesCant[NUMBERED_LIST_ITEM]++;}
<NUMBERED>"#"{1,20}			{lexemesCant[NUMBERED_LIST_ITEM]++; printEntry(yytext, tokenName[NUMBERED_LIST_ITEM]);}												
<NUMBERED>[^#\"\n"]+		{}														
<NUMBERED>"\n\n"			{BEGIN(0);}


"http://"[^ \n\t]*			{
								lexemesCant[HTTP]++; lexemesCant[TEXT]++;
								printEntry(tokenName[HTTP], tokenName[HTTP]); printEntry(yytext+7, tokenName[TEXT]);
							}
"[http://"					{
								lexemesCant[E_LINK_OPEN]++; lexemesCant[HTTP]++; 
								printEntry(tokenName[E_LINK_OPEN], tokenName[E_LINK_OPEN]); printEntry(tokenName[HTTP], tokenName[HTTP]);
								stateCaller = 0; BEGIN(ELINK);
							}
<ELINKNAME>" "*/\]			{BEGIN(ELINK);}
<ELINKNAME>[^\]]+			{	
								lexemesCant[E_LINK_SEPARATOR]++; lexemesCant[TEXT]++;
								printEntry(tokenName[E_LINK_SEPARATOR], tokenName[E_LINK_SEPARATOR]); printEntry(yytext+1, tokenName[TEXT]);
								BEGIN(ELINK);
							}
<ELINK>[^\] ]*				{lexemesCant[TEXT]++; printEntry(yytext, tokenName[TEXT]); BEGIN(ELINKNAME);}
<ELINK>\]					{lexemesCant[E_LINK_CLOSE]++;
							printEntry(tokenName[E_LINK_CLOSE], tokenName[E_LINK_CLOSE]);BEGIN(stateCaller);}


''/[^']        				{/*matchItalic(yyout);*/}
'''/[^']        			{/*matchBold(yyout);*/}
'''''/[^']        			{/*matchBoldItalic(yyout);*/}
^={2,6}.+={2,6}$			{/*matchHeading(yytext,yyout);*/}

"#REDIRECT [["				{
								lexemesCant[REDIRECT]++; lexemesCant[I_LINK_OPEN]++; 
								printEntry(tokenName[REDIRECT], tokenName[REDIRECT]);
								printEntry(tokenName[I_LINK_OPEN], tokenName[I_LINK_OPEN]);
								BEGIN(REDIREC);
							}
<REDIREC>[^\]]+				{lexemesCant[TEXT]++; printEntry(yytext, tokenName[TEXT]);}
<REDIREC>"]]"				{
								lexemesCant[I_LINK_CLOSE]++;
								printEntry(tokenName[I_LINK_CLOSE], tokenName[I_LINK_CLOSE]); BEGIN(0);
							}
			
"[["						{
								lexemesCant[I_LINK_OPEN]++;
								printEntry(tokenName[I_LINK_OPEN], tokenName[I_LINK_OPEN]); BEGIN(ILINK);
							}
<ILINK>[^\]\|]+				{lexemesCant[TEXT]++; printEntry(yytext, tokenName[TEXT]);}
<ILINK>\|[^\]]+				{
								lexemesCant[I_LINK_SEPARATOR]++; lexemesCant[TEXT]++;
								printEntry(tokenName[I_LINK_SEPARATOR], tokenName[I_LINK_SEPARATOR]);
								printEntry(yytext+1, tokenName[TEXT]);
							}
<ILINK>"]]"					{
								lexemesCant[I_LINK_CLOSE]++;
								printEntry(tokenName[I_LINK_CLOSE], tokenName[I_LINK_CLOSE]); BEGIN(0);
							}


"<ref name=\""[^"]+\">"[http://"	{
									//crear una referencia no solo usa tokens de referencia, sino tambien
									//tokens de link externo
									lexemesCant[REF_OPEN]++; lexemesCant[E_LINK_OPEN]++;
									lexemesCant[HTTP]++; //TODO name
									strncpy(references[refNum].refName, yytext + 11,
										yyleng - 11 - 10);
									BEGIN(REFCREATE);
									}
"<ref name=\""[^"]+\"" />"		{
								yytext[yyleng-4] = '\0';
								int num = 0;//getRefByName(yytext + 11);
								if (num != -1) {
									/*fprintf(yyout, "<sup id=\"cite_ref-%s-%d\"><a href=\"#cite_note-%s\">",
										references[num].refName, references[num].timesRef, 
										references[num].refName);*/
									references[num].timesRef++;
									/*fprintf(yyout, "<span>[</span>%d<span>]</span></a></sup>", num+1);*/
								}
								}
<REFCREATE>[^ ]+				{lexemesCant[TEXT]++; strcpy(references[refNum].link, yytext);}
<REFCREATE>" "[^\]]+\]			{
									lexemesCant[E_LINK_SEPARATOR]++; lexemesCant[TEXT]++;
									lexemesCant[E_LINK_CLOSE]++;
									strncpy(references[refNum].linkName, yytext+1, yyleng - 1 - 1);
								}

<REFCREATE>", "[^<]+"</ref>"	{
								lexemesCant[REF_SEPARATOR]++; lexemesCant[REF_CLOSE]++;
								strncpy(references[refNum].explanation, yytext + 2, yyleng - 2 - 6);
								/*fprintf(yyout, "<sup id=\"cite_ref-%s-%d\"><a href=\"#cite_note-%s\">",
									references[refNum].refName, 0, references[refNum].refName);*/
								references[refNum].timesRef = 1;
								/*fprintf(yyout, "<span>[</span>%d<span>]</span></a></sup>", ++refNum);*/
								BEGIN(0);
								}
								
("<references/>")|("{{Reflist}}")	{
										lexemesCant[REF_LIST]++; 
										printEntry(yytext, tokenName[REF_LIST]);
									}
								
<*>.		{/*no imprimo por default*/;}
<*>"\n"		{/*no imprimo*/;}
%%

int
main(int argc, char ** argv)
{
	//si se uso mal el programa
	if (argc != 2) {
		printf("Modo de uso: pwiki inputFile\n");
		return 0;
	}

	yyin = fopen(argv[1], "r");
	printf("Listado de tokens con los lexemas asociados:\n\n");
	printf("%-21s| %s\n", "Token", "Lexema asociado");
	printf("---------------------|---------------------\n");

	yylex();

	int i;
	printf("\nListado de cantidad de lexemas aparecidos por cada clase de token\n");
	printf("de token (no se muestran las clases con 0 apariciones)\n");
	for (i = 0; i < CANT_TOKEN; i++) {
		if (lexemesCant[i] != 0)
			printf("%s: %d\n", tokenName[i], lexemesCant[i]);
	}
	
	return 0;
}

void
printEntry(char * lexeme, char * token) {
	printf("%-21s| %s\n", token, lexeme);
}

