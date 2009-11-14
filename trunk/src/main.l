%{
#include <stdio.h>
#include "../include/match_functions.h"
%}

%%
''[^']*''	{matchItalic(yytext,yyout);}
'''[^']*''' {matchBold(yytext,yyout);}
%%

int
main(void)
{
yyin = fopen("../input", "r");
yyout = fopen("../out.html", "w");
fprintf(yyout, "<html><head></head><body>");
yylex();
fprintf(yyout, "</body></html>");
return 0;
}