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

void matchIndent(char *text, FILE *out){



}

void matchRedirect(char *text, FILE *out){
	fprintf(out, "%s<a href=\"/w/index.php?title=%s\">%s</a>",ARROW_TAG, text, text);

}

void matchExtLink(char * link, char * text, FILE *out){
	fprintf(out, "<a href=\"http://%s\" >%s</a>", link, text);
}
