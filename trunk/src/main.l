%{
#include <stdio.h>
#include "match_functions.h"
#include <string.h>


int elinkNum = 1;
int refNum = 0;

char str[MAX_LENGTH];
char str2[MAX_LENGTH];
char str3[MAX_LENGTH];

boolean inParagraph = TRUE;
boolean isThumb = FALSE;

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
%x IMAGE
%%

^:														{BEGIN(INDENT);strcpy(list.oTag,"<dl>");
															strcpy(list.cTag,"</dl>");
															strcpy(list.moTag,"<dd>");
															strcpy(list.mcTag,"</dd>");
															}
<INDENT>:{1,20}							{ list.matches[list.index].level = (int)strlen(yytext)-1;}												
<INDENT>[^:\n]+					{ 
															strcpy(list.matches[list.index].text,yytext); 	
															list.matches[list.index].level++;			
															list.index++;
															
							}
<INDENT>"\n"/[^:]							{matchList(&list,yyout);BEGIN(0);memset(&list,0,sizeof(tList));}
														
													
													
														
^"*"													  {BEGIN(BULLET);
															strcpy(list.oTag,"<ul>");
															strcpy(list.cTag,"</ul>");
															strcpy(list.moTag,"<li>");
															strcpy(list.mcTag,"</li>");
															}
															
															
<BULLET>"*"{1,20}							{ list.matches[list.index].level = (int)strlen(yytext)-1;}												
<BULLET>[^*\n]+						{ 
																strcpy(list.matches[list.index].text,yytext); 	
																list.matches[list.index].level++;			
																list.index++;
																}														
<BULLET>"\n"/[^\*]							{matchList(&list,yyout);BEGIN(0);memset(&list,0,sizeof(tList));	}
														
		
		
^"#"													 {BEGIN(NUMBERED);
																strcpy(list.oTag,"<ol>");
																strcpy(list.cTag,"</ol>");
																strcpy(list.moTag,"<li>");
																strcpy(list.mcTag,"</li>");
																}
<NUMBERED>"#"{1,20}							{ list.matches[list.index].level = (int)strlen(yytext)-1;}												
<NUMBERED>[^#\n]+					{ 
																strcpy(list.matches[list.index].text,yytext); 	
															  	list.matches[list.index].level++;			
																	list.index++;
															}														
<NUMBERED>"\n"/[^\#]							{matchList(&list,yyout);BEGIN(0);memset(&list,0,sizeof(tList));	}



"http://"[^ \n\t]*				{matchExtLink(yytext+7, yytext, yyout);}
"[http://"						{BEGIN(ELINK);}
<ELINKNAME>" "*/\]				{sprintf(str2, "[%d]", elinkNum++);BEGIN(ELINK);}
<ELINKNAME>[^\]]+				{strcpy(str2, yytext+1);BEGIN(ELINK);}
<ELINK>[^\] ]*					{strcpy(str, yytext); BEGIN(ELINKNAME);}
<ELINK>\]						{matchExtLink(str, str2, yyout); BEGIN(0);}


"\n"?"\n"/[=:\*]				{
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

"~"{3,5}					{matchSignature(strlen(yytext),yyout);}

''/[^']        				{matchItalic(yyout);}
'''/[^']        			{matchBold(yyout);}
'''''/[^']        			{matchBoldItalic(yyout);}
^={2}(={0,1}[^=]+)+={2}$	{matchHeading(yytext,yyout, 2);}
^={3}(={0,2}[^=]+)+={3}$	{matchHeading(yytext,yyout, 3);}
^={4}(={0,3}[^=]+)+={4}$	{matchHeading(yytext,yyout, 4);}
^={5}(={0,4}[^=]+)+={5}$	{matchHeading(yytext,yyout, 5);}
^={6}(={0,5}[^=]+)+={6}$	{matchHeading(yytext,yyout, 6);}

"#REDIRECT [["				{BEGIN(REDIREC);}
<REDIREC>[^\]]+				{matchRedirect(yytext,yyout);}
<REDIREC>"]]"				{BEGIN(0);}
			
"[["						{BEGIN(ILINK);}
<ILINK>[^\]\|]+				{strcpy(str,yytext);strcpy(str2,yytext);}
<ILINK>\|[^\]]+				{strcpy(str2,yytext+1);}
<ILINK>"]]"					{matchInterLink(str,str2,yyout);BEGIN(0);}


"<ref name=\""[^"]+\">"[http://"	{
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
<REFCREATE>[^ ]+				{strcpy(references[refNum].link, yytext);}
<REFCREATE>" "[^\]]+\]			{strncpy(references[refNum].linkName, yytext+1, yyleng - 1 - 1);}

<REFCREATE>", "[^<]+"</ref>"	{
								strncpy(references[refNum].explanation, yytext + 2, yyleng - 2 - 6);
								fprintf(yyout, "<sup id=\"cite_ref-%s-%d\"><a href=\"#cite_note-%s\">",
									references[refNum].refName, 0, references[refNum].refName);
								references[refNum].timesRef = 1;
								fprintf(yyout, "<span>[</span>%d<span>]</span></a></sup>", ++refNum);
								BEGIN(0);
								}
								
("<references/>")|("{{Reflist}}")	{
										//tengo que chequear si pongo un fin de parrafo
										if (inParagraph) {
											fprintf(yyout, "\n</p>\n");
											inParagraph = FALSE;
										}
										printReferences();
									}
									
"[[File:"[^\|\]]*				{
									strcpy(str, yytext+7); str2[0] = '\0'; str3[0] = '\0';
									BEGIN(IMAGE);
								}
<IMAGE>"|"						{/*si es el pipe del thumb o del alt, no matchea aca.*/}
<IMAGE>[^\|\]]*					{strcpy(str3, yytext);}
<IMAGE>"|thumb"					{isThumb = TRUE;}
<IMAGE>"|alt="[^\|\]]*			{strcpy(str2, yytext + 5);}
<IMAGE>"]]"						{matchImage(str, str2, str3, isThumb, yyout);isThumb=FALSE;BEGIN(0);}
									
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
		printf("%s.\n", argv[2]);
	}
	else {
		yyout = fopen("out.html", "w");
		printf("%s.\n", "out.html");
	}
	
	fprintf(yyout, "<html><head></head><body><p>");
	yylex();
	fprintf(yyout, "</body></html>");
	
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

