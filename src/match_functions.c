#include "match_functions.h"
#include <string.h>

void
matchItalic(char * text, FILE * out){
	text+=2;
	text[strlen(text)-2] = '\0';
	fprintf(out, "<i>%s</i>", text);
}

void matchBold(char * text, FILE * out){
	text+=3;
	text[strlen(text)-3] = '\0';
	fprintf(out, "<b>%s</b>", text);
}

void matchBoldItalic(char * text, FILE *out){
	text+=5;
	text[strlen(text)-5] = '\0';
	fprintf(out, "<i><b>%s</b></i>", text);
}

void matchHeading(char *text, FILE *out,unsigned int state){
	state++; //Sumamos uno por la estructura del heading {=}^n//
	text+=state;
	text[strlen(text)-state] = '\0';
	fprintf(out,"<h%d>%s<h%d>",state,text,state);
}