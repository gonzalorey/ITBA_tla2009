%{
#include <stdio.h>
#include "match_functions.h"
#include <string.h>


int elinkNum = 1;
int refNum = 0;
int stateCaller;

//vector con la cantidad de apariciones de cada lexema.
char * tokenName[CANT_TOKEN] = {"ITALIC", "BOLD", "I_LINK_OPEN", "I_LINK_SEPARATOR", "I_LINK_CLOSE",
	"E_LINK_OPEN", "E_LINK_SEPARATOR", "E_LINK_CLOSE", "HTTP", "REDIRECT", "HEAD1", "HEAD2", "HEAD3",
	"HEAD4", "HEAD5", "REF_OPEN", "REF_SEPARATOR", "REF_CLOSE", "REF_LIST", "BULLET_LIST_ITEM",
	"NUMBERED_LIST_ITEM", "INDENTING_ITEM", "IMAGE_OPEN", "IMAGE_CLOSE", "IMAGE_SEPARATOR",
	"IMAGE_ALT", "TEXT"};
int lexemesCant[CANT_TOKEN];

char str[MAX_LENGTH];
char str2[MAX_LENGTH];

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

^:														{BEGIN(INDENT);strcpy(list.oTag,"<dl>");
															strcpy(list.cTag,"</dl>");
															strcpy(list.moTag,"<dd>");
															strcpy(list.mcTag,"</dd>");
															}
<INDENT>:{1,20}							{ list.matches[list.index].level = (int)strlen(yytext)-1;}												
<INDENT>[^:\"\n"]+					{ 
															strcpy(list.matches[list.index].text,yytext); 	
															list.matches[list.index].level++;			
															list.index++;
															
							}
<INDENT>"\n\n"							{matchList(&list,yyout);BEGIN(0);memset(&list,0,sizeof(tList));}
														
													
													
														
^"*"													  {BEGIN(BULLET);
															strcpy(list.oTag,"<ul>");
															strcpy(list.cTag,"</ul>");
															strcpy(list.moTag,"<li>");
															strcpy(list.mcTag,"</li>");
															}
															
															
<BULLET>"*"{1,20}							{ list.matches[list.index].level = (int)strlen(yytext)-1;}												
<BULLET>[^*\"\n"]+						{ 
																strcpy(list.matches[list.index].text,yytext); 	
																list.matches[list.index].level++;			
																list.index++;
																}														
<BULLET>"\n\n"								{matchList(&list,yyout);BEGIN(0);memset(&list,0,sizeof(tList));	}
														
		
		
^"#"													 {BEGIN(NUMBERED);
																strcpy(list.oTag,"<ol>");
																strcpy(list.cTag,"</ol>");
																strcpy(list.moTag,"<li>");
																strcpy(list.mcTag,"</li>");
																}
<NUMBERED>"#"{1,20}							{ list.matches[list.index].level = (int)strlen(yytext)-1;}												
<NUMBERED>[^#\"\n"]+					{ 
																strcpy(list.matches[list.index].text,yytext); 	
															  	list.matches[list.index].level++;			
																	list.index++;
															}														
<NUMBERED>"\n\n"							{matchList(&list,yyout);BEGIN(0);memset(&list,0,sizeof(tList));	}



"http://"[^ \n\t]*					{lexemesCant[HTTP]++; lexemesCant[TEXT]++; matchExtLink(yytext+7, yytext, yyout);}
"[http://"								{lexemesCant[E_LINK_OPEN]++; lexemesCant[HTTP]++; stateCaller = 0; BEGIN(ELINK);}
<ELINKNAME>" "*/\]				{sprintf(str2, "[%d]", elinkNum++);BEGIN(ELINK);}
<ELINKNAME>[^\]]+					{	
														lexemesCant[E_LINK_SEPARATOR]++; lexemesCant[TEXT]++; 
														 strcpy(str2, yytext+1);BEGIN(ELINK);
														}
<ELINK>[^\] ]*							{lexemesCant[TEXT]++; strcpy(str, yytext); BEGIN(ELINKNAME);}
<ELINK>\]									{lexemesCant[E_LINK_CLOSE]++; matchExtLink(str, str2, yyout); BEGIN(stateCaller);}


"\n"?"\n"/[=:\*]					{
															if (inParagraph) {
																fprintf(yyout, "\n</p>\n");
																inParagraph = FALSE;
																}
													}
													
"\n\n"							{
											if (inParagraph)
												fprintf(yyout, "\n</p>\n<p>\n");
											else
												fprintf(yyout, "\n<p>\n");
											inParagraph = TRUE;
										}
"\n"						{
								if (!inParagraph) {
									fprintf(yyout, "\n<p>\n");
									inParagraph = TRUE;
								}
							}


''/[^']        				{matchItalic(yyout);}
'''/[^']        			{matchBold(yyout);}
'''''/[^']        			{matchBoldItalic(yyout);}
^={2,6}.+={2,6}$			{matchHeading(yytext,yyout);}

"#REDIRECT [["				{lexemesCant[REDIRECT]++; lexemesCant[I_LINK_OPEN]++; BEGIN(REDIREC);}
<REDIREC>[^\]]+				{lexemesCant[TEXT]++; matchRedirect(yytext,yyout);}
<REDIREC>"]]"				{lexemesCant[I_LINK_CLOSE]++; BEGIN(0);}
			
"[["						{lexemesCant[I_LINK_OPEN]++; BEGIN(ILINK);}
<ILINK>[^\]\|]+				{lexemesCant[TEXT]++; strcpy(str,yytext);strcpy(str2,yytext);}
<ILINK>\|[^\]]+				{lexemesCant[I_LINK_SEPARATOR]++; lexemesCant[TEXT]++; strcpy(str2,yytext+1);}
<ILINK>"]]"					{lexemesCant[I_LINK_CLOSE]++; matchInterLink(str,str2,yyout);BEGIN(0);}


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
								int num = getRefByName(yytext + 11);
								if (num != -1) {
									fprintf(yyout, "<sup id=\"cite_ref-%s-%d\"><a href=\"#cite_note-%s\">",
										references[num].refName, references[num].timesRef, 
										references[num].refName);
									references[num].timesRef++;
									fprintf(yyout, "<span>[</span>%d<span>]</span></a></sup>", num+1);
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
								fprintf(yyout, "<sup id=\"cite_ref-%s-%d\"><a href=\"#cite_note-%s\">",
									references[refNum].refName, 0, references[refNum].refName);
								references[refNum].timesRef = 1;
								fprintf(yyout, "<span>[</span>%d<span>]</span></a></sup>", ++refNum);
								BEGIN(0);
								}
								
("<references/>")|("{{Reflist}}")	{
										lexemesCant[REF_LIST]++; 
										//tengo que chequear si pongo un fin de parrafo
										if (inParagraph) {
											fprintf(yyout, "\n</p>\n");
											inParagraph = FALSE;
										}
										printReferences();
									}
%%

int
main(int argc, char ** argv)
{
	//si se uso mal el programa
	if (argc < 2 || argc > 3) {
		printf("Modo de uso: pwiki [inputFile [outputFile]]\n");
		return 0;
	}
	
	list.index = 0;

	
	
	printf("Se leyo del archivo %s, y se genero la salida en el archivo ", argv[1]);
	yyin = fopen(argv[1], "r");
	if (argc == 3) {
		yyout = fopen(argv[2], "w");
		printf("%s.\n\n", argv[2]);
	}
	else {
		yyout = fopen("out.html", "w");
		printf("%s.\n\n", "out.html");
	}
	
	fprintf(yyout, "<html><head></head><body><p>");
	yylex();
	fprintf(yyout, "</body></html>");

	int i;
	printf("Listado de cantidad de lexemas aparecidos por cada clase\n");
	printf("de token (no se muestran las clases con 0 apariciones)\n");
	for (i = 0; i < CANT_TOKEN; i++) {
		if (lexemesCant[i] != 0)
			printf("%s: %d\n", tokenName[i], lexemesCant[i]);
	}
	
	return 0;
}

void
printReferences() {
	int i, j;
	
	fprintf(yyout, "<ol class=\"references\">");
	for (i = 0; i < refNum; i++) {
		fprintf(yyout, "<li id=\"cite_note-%s\">", references[i].refName);
		if (references[i].timesRef == 1) {
			fprintf(yyout, "<b><a href=\"#cite_ref-%s-%d\">^</a></b>", references[i].refName, 1);
		}
		else {
			fprintf(yyout, "^");
			for (j = 0; j < references[i].timesRef; j++)
				fprintf(yyout, " <sup><b><a href=\"#cite_ref-%s-%d\">%c</a></b></sup>",
					references[i].refName, j, 'a' + j);
		}
		fprintf(yyout, " <a href=\"http://%s\">%s</a>, %s</li>", references[i].link,
			references[i].linkName, references[i].explanation);
	}
	fprintf(yyout, "</ol>");
}

int
getRefByName(char * name) {
	int i;
	for (i = 0; i < refNum; i++) {
		if (strcmp(name, references[i].refName) == 0) {
			return i;
		}
	}
	return -1;
}

