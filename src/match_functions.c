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
		fprintf(out, "<b><i>");
	else
		fprintf(out, "</i></b>");
	itaBold = !itaBold;
}

void matchHeading(char *text, FILE *out, int cantEquals){
	int l = strlen(text);
	int counter;

	counter = cantEquals - 1;
	text[l-cantEquals] = '\0';

	fprintf(out, "<h%d>%s</h%d>", counter, text + cantEquals, counter);
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

void matchSignature(int cant,FILE *out){

	struct tm *local;
	time_t t;

	t = time(NULL);
	local = gmtime(&t);


	switch(cant){
		case 3:  fprintf(out,"<a href=http://en.wikipedia.org/wiki/User:%s>%s</a>",USER_NAME,USER_NAME);
		break;
		case 4: fprintf(out,"<a href=http://en.wikipedia.org/wiki/User:%s>%s</a> %s",USER_NAME,USER_NAME,asctime(local));
		break;
		case 5: fprintf(out,"%s",asctime(local));
		break;
		default:
		break;
	}


}

void
matchImage(char * str, char * str2, char * str3, boolean isThumb, FILE * out) {
	if (isThumb) {
		fprintf(out, "<div><a href=\"wiki/File:%s\">", str);
		fprintf(out, "<img src=\"%s\" width=\"180\" alt=\"%s\"/></a>", str, str2);
		fprintf(out, "<div>%s</div></div>", str3);
	}
	else {
		fprintf(out, "<a title=\"%s\" href=\"wiki/File:%s\">", str3, str);
		fprintf(out, "<img src=\"%s\" alt=\"%s\"/></a>", str, str2);
	}
}



