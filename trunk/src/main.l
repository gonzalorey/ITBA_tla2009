%{
#include <stdio.h>
#include "../include/match_functions.h"
%}

%%
''[^']*''	{matchItalic(yytext,yyout);};
'''[^']*''' {matchBold(yytext,yyout);};
%%


main()
{
yyin = fopen("../input", "r");
yyout = fopen("../out.html", "w");
yylex();
return 0;
}