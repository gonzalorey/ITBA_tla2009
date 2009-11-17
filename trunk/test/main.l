
%{
#include<stdio.h>
#include<stdlib.h>
#include"match_functions.h"

FILE *out;
FILE *in;

#define LENGTH 10

/*typedef struct {
	char open[LENGTH];
	char close[LENGTH];
} tag_t;



static tag_t italicTag;


void processTag(yyscan_t scanner, char *text, int length, tag_t *tag);

*/

//TODO: Pegar en el informe: http://flex.sourceforge.net/manual/Reentrant-Uses.html#Reentrant-Uses

%}

%option reentrant noyywrap
%option outfile = "main.c"


%x ELINK
%x ELINKNAME
%x REDIRECT

%%
'{5}[^']+'{5}	{
			yyscan_t scanner;
			YY_BUFFER_STATE buf;
			
			yylex_init(&scanner);
			
			yyset_in(yyin, scanner);
			yyset_out(yyout, scanner);
			
								
			yytext[yyleng-5] = '\0';
			
			buf = yy_scan_string(yytext+5, scanner);
			
			fprintf(yyout, "<i><strong>");
			
			yylex(scanner);
			
			fprintf(yyout, "</strong></i>");
			
			
			yy_delete_buffer(buf, scanner);
			yylex_destroy(scanner);
		}


'{3}[^']+'{3}	{
			yyscan_t scanner;
			YY_BUFFER_STATE buf;
			
			yylex_init(&scanner);
			
			yyset_in(yyin, scanner);
			yyset_out(yyout, scanner);
			
								
			yytext[yyleng-3] = '\0';
			
			buf = yy_scan_string(yytext+3, scanner);
			
			fprintf(yyout, "<strong>");
			
			yylex(scanner);
			
			fprintf(yyout, "</strong>");
			
			yy_delete_buffer(buf, scanner);
			yylex_destroy(scanner);
		}
		
'{2}[^']+'{2}	{

		//processTag(yyscanner, yytext, yyleng, &italicTag);
		
		yyscan_t scanner;
		YY_BUFFER_STATE buf;
				
		yylex_init(&scanner);

		yyset_in(yyin, scanner);
		yyset_out(yyout, scanner);
		
		yytext[yyleng-2] = '\0';
		
		buf = yy_scan_string(yytext+2, scanner);
		
		fprintf(yyout, "<i>");
		
		yylex(scanner);
		
		fprintf(yyout, "</i>");

		
		yy_delete_buffer(buf, scanner);
		yylex_destroy(scanner);
	
		
		
		}

"http://"[^ ]*	{ 
			fprintf(yyout, "<a href = \"%s\">%s</a>", yytext, yytext);

		}

.	ECHO;

%%

int main(int argc, char *argv[]){
	yyscan_t scanner;
     
	FILE *in = fopen(argv[1], "r");;
	FILE *out = fopen("out.html", "w");
	
//	strcpy(italicTag.open, "<i>");
//	strcpy(italicTag.open, "</i>");

	yylex_init ( &scanner );

	yyset_in(in, scanner);
	yyset_out(out, scanner);     
     
	yylex ( scanner );
	yylex_destroy ( scanner );
return 0;

}


/*
void processTag(yyscan_t yyscanner, char *yytext, int yyleng, tag_t *tag){
	yyscan_t scanner;
	YY_BUFFER_STATE buf;
			
	yylex_init(&scanner);

	yyset_in(yyget_in(yyscanner), scanner);
	yyset_out(yyget_out(yyscanner), scanner);
	
	yytext[yyleng-2] = '\0';
	
	fprintf(yyout, "%s", tag->open);
	
	buf = yy_scan_string(yytext+2, scanner);
	yylex(scanner);
	
	fprintf(yyout, "%s", tag->close);

	
	yy_delete_buffer(buf, scanner);
	yylex_destroy(scanner);
	
}


 
			yyscan_t scanner;
			YY_BUFFER_STATE buf;
					
			yylex_init(&scanner);

			yyset_in(yyget_in(yyscanner), scanner);
			yyset_out(yyget_out(yyscanner), scanner);
			
			yytext[yyleng-2] = '\0';
			
			fprintf(yyout, "<i>");
			
			buf = yy_scan_string(yytext+2, scanner);
			yylex(scanner);
			
			fprintf(yyout, "</i>");

			
			yy_delete_buffer(buf, scanner);
			yylex_destroy(scanner);
*/
