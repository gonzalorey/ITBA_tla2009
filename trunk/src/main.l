%{
#include <stdio.h>
#include "match_functions.h"

#define MAX_LENGTH 150

int elinkNum = 1;
char str[MAX_LENGTH];
char str2[MAX_LENGTH];
%}

%x ELINK
%x ELINKNAME
%x ILINK
%x ILINKPIPE
%x REDIREC

%%
"http://"[^ ]*$					{matchExtLink(yytext+7, yytext, yyout);}
"[http://"							BEGIN(ELINK);
<ELINKNAME>" "*/\]			{sprintf(str2, "[%d]", elinkNum++);BEGIN(ELINK);}
<ELINKNAME>[^\]]+				{strcpy(str2, yytext+1);BEGIN(ELINK);}
<ELINK>[^\] ]*					{strcpy(str, yytext); BEGIN(ELINKNAME);}
<ELINK>\]								{matchExtLink(str, str2, yyout); BEGIN(0);}
"\n"										{fprintf(yyout, "<br/>");}
''[^']*''        				{matchItalic(yytext,yyout);}
'''[^']*'''       			{matchBold(yytext,yyout);}
'''''[^']*'''''  				{matchBoldItalic(yytext,yyout);}
={2,6}.+={2,6}					{matchHeading(yytext,yyout);}
:{1,3}.+								{matchIndent(yytext,yyout);}

"#REDIRECT [["					BEGIN(REDIREC);
<REDIREC>[^\]]+					{matchRedirect(yytext,yyout);}
<REDIREC>"]]"						BEGIN(0);
			
"[["									{BEGIN(ILINK);}
<ILINK>[^\]\|]+				{strcpy(str,yytext);strcpy(str2,yytext);}
<ILINK>\|[^\]]+				{strcpy(str2,yytext+1);}
<ILINK>"]]"						{matchInterLink(str,str2,yyout);BEGIN(0);}

%%

int
main(int argc, char ** argv)
{
	//si se uso mal el programa
	if ( argc < 2 || argc > 3) {
		printf("Modo de uso: pwiki inputFile [outputFile]\n");
		return 0;
	}
	
	yyin = fopen(argv[1], "r");
	if (argc == 3)
		yyout = fopen(argv[2], "w");
	else
		yyout = fopen("out.html", "w");
	
	fprintf(yyout, "<html><head></head><body>");
	yylex();
	fprintf(yyout, "</body></html>");
	return 0;
}

