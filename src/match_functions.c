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




void matchList(tList * ref, FILE *out){
	
	
	if(DEBUG){
	int i;	
	for(i=0; i< ref->index;i++)
		fprintf(out,"{\"%s\",%d}\n",ref->matches[i].text,ref->matches[i].level);
	
	}

	if( ref->index != 0)
	recursiveList(ref,out,ref->index);


}

void recursiveList(tList *ref,FILE *out,int index){

	int i,j;
	int place = ref->index-index;
	int relativeLevel; 

	if(index==0)
		return;

	if(place >0)
		relativeLevel = ref->matches[place].level - ref->matches[place-1].level;
	else
		relativeLevel = ref->matches[place].level;



		if(  relativeLevel == 0 ){
				fprintf(out,"%s%s%s",ref->moTag,ref->matches[place].text,ref->mcTag);	
		}


		if(  relativeLevel < 0 ){

			for(j=0;j < -1*relativeLevel;j++)
				fprintf(out,"%s%s",ref->mcTag,ref->cTag);
			fprintf(out,"%s%s%s",ref->moTag,ref->matches[place].text,ref->mcTag);
		}

		if(  relativeLevel > 0 ){

			for(j=0;j< relativeLevel;j++)
				fprintf(out,"%s%s",ref->oTag,ref->moTag);
			fprintf(out,"%s",ref->matches[place].text);
		}

	
		recursiveList(ref,out,index-1);
		fprintf(out,"%s%s",ref->mcTag,ref->cTag);





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
