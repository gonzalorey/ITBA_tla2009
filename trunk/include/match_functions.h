#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdio.h>

#define ARROW_TAG "<img alt=\"Redirect arrow without text.svg\" src=\"http://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Redirect_arrow_without_text.svg/30px-Redirect_arrow_without_text.svg.png\" width=\"30\" height=\"13\">"
#define MAX_LENGTH 150
#define REF_CANT   20
#define MAX_INDENT 10


typedef struct{
	char text[MAX_LENGTH];
	unsigned int level; //De 1 a MAX_INDENT;
}indentRef;

typedef struct{
	indentRef indents[MAX_LENGTH];
	int index;
}tIndent;




void matchItalic(char *text, FILE * out);
void matchBold(char *text, FILE * out);
void matchBoldItalic(char * text, FILE *out);
void matchHeading(char *text, FILE *out);
void matchIndent(tIndent * ref, FILE *out);
void matchRedirect(char *text, FILE *out);
void matchExtLink(char * link, char * text, FILE *out);
void matchInterLink(char *text, char * title, FILE *out);
void recursiveIndent(tIndent *ref,FILE *out,int index);

#endif /* MATCHFUNCTION_H_ */


