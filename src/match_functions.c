#include "match_functions.h"
#include <string.h>



void
matchItalic(FILE * out){
	static boolean italic = FALSE;
	if (!italic)
		fprintf(out, "<i>");
	else
		fprintf(out, "</i>");
	italic = !italic;
}

void matchBold(FILE * out){
	static boolean bold = FALSE;
	if (!bold)
		fprintf(out, "<b>");
	else
		fprintf(out, "</b>");
	bold = !bold;
}

void matchBoldItalic(FILE *out){
	static boolean itaBold = FALSE;
	if (!itaBold)
		fprintf(out, "<b>");
	else
		fprintf(out, "</b>");
	itaBold = !itaBold;
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




void matchIndent(tIndent * ref, FILE *out){

	if( ref->index != 0)
	recursiveIndent(ref,out,ref->index);


}

void recursiveIndent(tIndent *ref,FILE *out,int index){

	int i,j;
	int place = ref->index-index;
	int relativeLevel; // La base es uno

	if(index==0)
		return;

	if(place >0)
		relativeLevel = ref->indents[place].level - ref->indents[place-1].level;
	else
		relativeLevel = ref->indents[place].level;



		if(  relativeLevel == 0 ){
				fprintf(out,"<dd>%s</dd>",ref->indents[place].text);
				recursiveIndent(ref,out,index-1);
				return;
		}


		if(  relativeLevel < 0 ){

			for(j=0;j < -1*relativeLevel;j++)
				fprintf(out,"</dd></dl>");
		}

		if(  relativeLevel > 0 ){

			for(j=0;j< relativeLevel;j++)
				fprintf(out,"<dl><dd>");

		}

		fprintf(out,"%s",ref->indents[place].text);
		recursiveIndent(ref,out,index-1);
		fprintf(out,"</dd></dl>");






}


void matchInterLink(char *text, char * title, FILE *out){
	fprintf(out, "<a href=\"/w/index.php?title=%s\">%s</a>", text, title);

}


void matchRedirect(char *text, FILE *out){
	fprintf(out, "%s<a href=\"/w/index.php?title=%s\">%s</a>",ARROW_TAG, text, text);

}

void matchExtLink(char * link, char * text, FILE *out){
	fprintf(out, "<a href=\"http://%s\">%s</a>", link, text);
}
