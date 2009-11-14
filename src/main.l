%{
#include <stdio.h>
#include "../include/italic.h"
%}

%%
''[^']*''	{matchItalic(yytext, yyout);};
%%

main()
{
yyin = fopen("../input", "r");
yyout = fopen("../out.html", "w");
yylex();
return 0;
}