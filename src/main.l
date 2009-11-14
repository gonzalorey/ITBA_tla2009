%{
#include <stdio.h>
void matchItalic(char *text);
%}

%%
''[^']*''	{matchItalic(yytext);};
%%

void matchItalic(char *text){
	text+=2;
	text[strlen(text)-2] = '\0';
	fprintf(yyout, "<i>%s</i>", text);
}

main()
{
yyin = fopen("../input", "r");
yyout = fopen("out.html", "w");
yylex();
return 0;
}