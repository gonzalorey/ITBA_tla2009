#include "flex.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
	yyscan_t scanner;
     
//	FILE *in = fopen(argv[1], "r");;
//	FILE *out = fopen("out.html", "w");
	
		

	yylex_init ( &scanner );

//	yyset_in(in, scanner);
//	yyset_out(out, scanner);


   
	yylex ( scanner );
	yylex_destroy ( scanner );
	
	return 0;
}
