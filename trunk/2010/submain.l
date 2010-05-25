/*++++++++++++++++++++++++++++++++++ Seccion de definiciones ++++++++++++++++++++++++++++++++++++*/
%{
#include <stdio.h> 
%}

/* Estados */
%s		IN_COMMENTARY

/*+++++++++++++++++++++++++++++++++ Seccion de reglas /yylex ++++++++++++++++++++++++++++++++++++*/
%%
[" "\t\n]		;

<INITIAL>"/*" {
	BEGIN(IN_COMMENTARY);
}

<IN_COMMENTARY>"*/" {
	BEGIN(INITIAL);
}

<IN_COMMENTARY>. ;

%%

/*++++++++++++++++++++++++++++++ Seccion de funciones de usuario ++++++++++++++++++++++++++++++++*/
int
main(void)
{
	yylex();
}
