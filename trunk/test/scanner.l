%{
#include<stdio.h>
#include<stdlib.h>
#include "match.h"
//TODO: Pegar en el informe: http://flex.sourceforge.net/manual/Reentrant-Uses.html#Reentrant-Uses

%}

%option reentrant noyywrap
%option outfile = "scanner.c"
%option header-file="flex.h"

%%
'{5}([^']|[^']'{1,4}|[^']{6,})+'{5} {matchBoldItalic(yytext, yyleng, yyin, yyout); }

'{3}([^']|[^']'|[^']'{2}|[^']{4,})+'{3}	{ matchBold(yytext, yyleng, yyin, yyout);}
		
'{2}([^']|[^']'|[^']'{3})+'{2}	{ matchItalic(yytext, yyleng, yyin, yyout); }


^={2,6}.+={2,6}$	{matchHeading(yytext,yyout);}



"http://"[^ ]*	{ 
			fprintf(yyout, "<a href = \"%s\">%s</a>", yytext, yytext);

		}

.	ECHO;
%%



