%{
#include <stdio.h>
#include <string.h>

void printEntry(char * lexeme, char * token);
void printHeaderEntry(int headNum);

typedef enum{ITALIC, BOLD, ITABOLD, I_LINK_OPEN, I_LINK_SEPARATOR, I_LINK_CLOSE, E_LINK_OPEN,
	E_LINK_SEPARATOR, E_LINK_CLOSE, HTTP, REDIRECT, HEAD1, HEAD2, HEAD3,
	HEAD4, HEAD5, REF_OPEN, REF_NAME, REF_NAME_ALT, REF_SEPARATOR, REF_CLOSE, REF_LIST, BULLET_LIST_ITEM,
	NUMBERED_LIST_ITEM, INDENTING_ITEM, IMAGE_OPEN, IMAGE_CLOSE, IMAGE_SEPARATOR, IMAGE_THUMB,
	IMAGE_ALT, SIGNATURE, TEXT} tokens;

//TEXT + 1 porque TEXT es el ultimo elemento del enum de tokens.
#define CANT_TOKEN (TEXT+1)

//vector con la cantidad de apariciones de cada lexema.
char * tokenName[CANT_TOKEN] = {"''", "'''", "'''''", "[[", "|", "]]",
	"[", "(espacio en blanco)", "]", "http://", "#REDIRECT", "==", "===", "====",
	"=====", "======", "<ref name=\"", "\">", "\" />", ", ", "</ref>", "REF_LIST", "BULLET_LIST_ITEM",
	"NUMBERED_LIST_ITEM", "INDENTING_ITEM", "[[File:", "]]", "|", "thumb", "alt=", "SIGNATURE", "TEXT"};
	
int lexemesCant[CANT_TOKEN];

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
%x IMAGE
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
								BEGIN(ELINK);
							}
<ELINKNAME>" "*/\]			{BEGIN(ELINK);}
<ELINKNAME>[^\]]+			{	
								lexemesCant[E_LINK_SEPARATOR]++; lexemesCant[TEXT]++;
								printEntry(tokenName[E_LINK_SEPARATOR], tokenName[E_LINK_SEPARATOR]); printEntry(yytext+1, tokenName[TEXT]);
								BEGIN(ELINK);
							}
<ELINK>[^\] ]*				{lexemesCant[TEXT]++; printEntry(yytext, tokenName[TEXT]); BEGIN(ELINKNAME);}
<ELINK>\]					{lexemesCant[E_LINK_CLOSE]++;
							printEntry(tokenName[E_LINK_CLOSE], tokenName[E_LINK_CLOSE]);BEGIN(0);}


''/[^']        				{lexemesCant[ITALIC]++; printEntry(tokenName[ITALIC], tokenName[ITALIC]);}
'''/[^']        			{lexemesCant[BOLD]++; printEntry(tokenName[BOLD], tokenName[BOLD]);}
'''''/[^']        			{lexemesCant[ITABOLD]++; printEntry(tokenName[ITABOLD], tokenName[ITABOLD]);}
^={2}(={0,1}[^=]+)+={2}$	{printHeaderEntry(HEAD1);}
^={3}(={0,2}[^=]+)+={3}$		{printHeaderEntry(HEAD2);}
^={4}(={0,3}[^=]+)+={4}$		{printHeaderEntry(HEAD3);}
^={5}(={0,4}[^=]+)+={5}$		{printHeaderEntry(HEAD4);}
^={6}(={0,5}[^=]+)+={6}$		{printHeaderEntry(HEAD5);}

"~"{3,5}					{lexemesCant[SIGNATURE]++;printEntry(yytext, tokenName[SIGNATURE]);}

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
									lexemesCant[REF_OPEN]++; lexemesCant[TEXT]++; lexemesCant[REF_NAME]++;
									lexemesCant[E_LINK_OPEN]++; lexemesCant[HTTP]++;
									printEntry(tokenName[REF_OPEN], tokenName[REF_OPEN]);
									yytext[yyleng - 10] = '\0';
									printEntry(yytext+11, tokenName[TEXT]);
									printEntry(tokenName[REF_NAME], tokenName[REF_NAME]);
									printEntry(tokenName[E_LINK_OPEN], tokenName[E_LINK_OPEN]);
									printEntry(tokenName[HTTP], tokenName[HTTP]);
									BEGIN(REFCREATE);
									}
"<ref name=\""[^"]+\"" />"		{
									lexemesCant[REF_OPEN]++; lexemesCant[TEXT]++; lexemesCant[REF_NAME_ALT]++;
									printEntry(tokenName[REF_OPEN], tokenName[REF_OPEN]);
									yytext[yyleng - 4] = '\0';
									printEntry(yytext+11, tokenName[TEXT]);
									printEntry(tokenName[REF_NAME_ALT], tokenName[REF_NAME_ALT]);
								}
<REFCREATE>[^ ]+				{lexemesCant[TEXT]++; printEntry(yytext, tokenName[TEXT]);}
<REFCREATE>" "[^\]]+\]			{
									lexemesCant[E_LINK_SEPARATOR]++; lexemesCant[TEXT]++;
									lexemesCant[E_LINK_CLOSE]++;
									yytext[yyleng-1] = '\0';
									printEntry(tokenName[E_LINK_SEPARATOR], tokenName[E_LINK_SEPARATOR]);
									printEntry(yytext+1, tokenName[TEXT]);
									printEntry(tokenName[E_LINK_CLOSE], tokenName[E_LINK_CLOSE]);
								}

<REFCREATE>", "[^<]+"</ref>"	{
								lexemesCant[REF_SEPARATOR]++; lexemesCant[TEXT]++;
								lexemesCant[REF_CLOSE]++;
								printEntry(tokenName[REF_SEPARATOR], tokenName[REF_SEPARATOR]);
								yytext[yyleng-6] = '\0';
								printEntry(yytext+2, tokenName[TEXT]);
								printEntry(tokenName[REF_CLOSE], tokenName[REF_CLOSE]);

								BEGIN(0);
								}
								
("<references/>")|("{{Reflist}}")	{
										lexemesCant[REF_LIST]++; 
										printEntry(yytext, tokenName[REF_LIST]);
									}
									
"[[File:"[^\|\]]*			{
								lexemesCant[IMAGE_OPEN]++; lexemesCant[TEXT]++; 
								printEntry(tokenName[IMAGE_OPEN], tokenName[IMAGE_OPEN]); 
								printEntry(yytext+7, tokenName[TEXT]); BEGIN(IMAGE);
							}
<IMAGE>"|"					{
								lexemesCant[IMAGE_SEPARATOR]++;
								printEntry(tokenName[IMAGE_SEPARATOR], tokenName[IMAGE_SEPARATOR]);
							}
<IMAGE>[^\|\]]*				{lexemesCant[TEXT]++; printEntry(yytext, tokenName[TEXT]);}
<IMAGE>"|thumb"				{
								lexemesCant[IMAGE_SEPARATOR]++;lexemesCant[IMAGE_THUMB]++;
								printEntry(tokenName[IMAGE_SEPARATOR], tokenName[IMAGE_SEPARATOR]);
								printEntry(tokenName[IMAGE_THUMB], tokenName[IMAGE_THUMB]);
							}
<IMAGE>"|alt="[^\|\]]*		{
								lexemesCant[IMAGE_SEPARATOR]++; lexemesCant[IMAGE_ALT]++;
								lexemesCant[TEXT]++;
								printEntry(tokenName[IMAGE_SEPARATOR], tokenName[IMAGE_SEPARATOR]);
								printEntry(tokenName[IMAGE_ALT], tokenName[IMAGE_ALT]);
								printEntry(yytext + 5, tokenName[TEXT]);
							}
<IMAGE>"]]"					{
								lexemesCant[IMAGE_CLOSE]++;
								printEntry(tokenName[IMAGE_CLOSE], tokenName[IMAGE_CLOSE]);
								BEGIN(0);
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
	printf("\nListado de cantidad de lexemas aparecidos por cada clase\n");
	printf("de token (no se muestran las clases con 0 apariciones)\n\n");
	printf("%-21s| %s\n", "Token", "Cantidad de lexemas");
	printf("---------------------|---------------------\n");
	for (i = 0; i < CANT_TOKEN; i++) {
		if (lexemesCant[i] != 0)
			printf("%-21s| %d\n", tokenName[i], lexemesCant[i]);
	}
	
	return 0;
}

void
printEntry(char * lexeme, char * token) {
	printf("%-21s| %s\n", token, lexeme);
}

void
printHeaderEntry(int headNum) {
	int cantEquals = headNum - HEAD1 + 2;
	lexemesCant[headNum]+=2; lexemesCant[TEXT]++;
	printEntry(tokenName[headNum], tokenName[headNum]);
	yytext[yyleng-cantEquals] = '\0';
	printEntry(yytext+cantEquals, tokenName[TEXT]);
	printEntry(tokenName[headNum], tokenName[headNum]);
}
