#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdio.h>

#define ARROW_TAG "<img alt=\"Redirect arrow without text.svg\" src=\"http://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Redirect_arrow_without_text.svg/30px-Redirect_arrow_without_text.svg.png\" width=\"30\" height=\"13\">"
#define MAX_LENGTH 150
#define TAG_LENGTH 10
#define REF_CANT   20
#define MAX_INDENT 50

#define DEBUG FALSE


typedef struct{
	char text[MAX_LENGTH];
	unsigned int level; //De 1 a MAX_INDENT;
}listRef;

typedef struct{
	listRef matches[MAX_LENGTH];
	char oTag[TAG_LENGTH];
	char cTag[TAG_LENGTH];
	char moTag[TAG_LENGTH];
	char mcTag[TAG_LENGTH];
	int index;
}tList;


typedef enum{FALSE, TRUE} boolean;

void matchItalic(FILE * out);
void matchBold(FILE * out);
void matchBoldItalic(FILE *out);
void matchHeading(char *text, FILE *out);
void matchRedirect(char *text, FILE *out);
void matchExtLink(char * link, char * text, FILE *out);
void matchInterLink(char *text, char * title, FILE *out);
void matchList(tList * ref, FILE *out);
void recursiveList(tList *ref,FILE *out,int index);

#endif /* MATCHFUNCTION_H_ */


