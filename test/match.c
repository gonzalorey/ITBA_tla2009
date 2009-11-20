#include "match.h"
#include <string.h>
#include <stdlib.h>
#include "flex.h"


typedef struct {
	char open[MAX_LENGTH];
	char close[MAX_LENGTH];
	int begin_cut;
	int end_cut;
} tag_t;

static void processTag(char *str, int length,FILE *in, FILE *out, tag_t *tag);


static tag_t italicTag = {"<i>", "</i>", 2, 2};
static tag_t boldTag = { "<b>", "</b>", 3, 3};
static tag_t boldItalicTag = { "<i><strong>", "</strong></i>", 5, 5};

void matchItalic(char *str, int length,FILE *in, FILE *out){
	processTag(str, length, in, out,&italicTag);
}

void matchBold(char *str, int length,FILE *in, FILE *out){
	processTag(str, length, in, out,&boldTag);
}

void matchBoldItalic(char *str, int length,FILE *in, FILE *out){
	processTag(str, length, in, out,&boldItalicTag);
}

void matchHeading(char *text, FILE *out){
        int l = strlen(text);
        int counter, i;

        for( counter=0, i=0; i<l/2; i++)
                if(text[i] == '=')
                        counter++;

        text+= counter;
        text[strlen(text)-counter] = '\0';
        counter--;
        fprintf(out,"<h%d>%s</h%d>",counter,text,counter);
}




static void processTag(char *str, int length,FILE *in, FILE *out, tag_t *tag){
	yyscan_t scanner;
	YY_BUFFER_STATE buf;
			
	yylex_init(&scanner);

	yyset_in(in, scanner);
	yyset_out(out, scanner);
	
	str[length-tag->end_cut] = '\0';
	
	buf = yy_scan_string(str+tag->begin_cut, scanner);
	
	fprintf(out, "%s", tag->open);
	
	yylex(scanner);
	
	fprintf(out, "%s", tag->close);

	
	yy_delete_buffer(buf, scanner);
	yylex_destroy(scanner);
	
}

