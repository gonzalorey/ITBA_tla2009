#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdio.h>

#define ARROW_TAG "<img alt=\"Redirect arrow without text.svg\" src=\"http://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Redirect_arrow_without_text.svg/30px-Redirect_arrow_without_text.svg.png\" width=\"30\" height=\"13\">"
#define MAX_LENGTH 150
#define TAG_LENGTH 10
#define REF_CANT   20
#define MAX_INDENT 50

#define DEBUG FALSE

//TEXT + 1 porque TEXT es el ultimo elemento del enum de tokens.
#define CANT_TOKEN (TEXT+1)

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

typedef struct{
	char refName[REF_CANT];
	char link[MAX_LENGTH];
	char linkName[MAX_LENGTH];
	char explanation[MAX_LENGTH*3];
	int timesRef;	//cantidad de referencias que se hicieron
}refElem;


typedef enum{ITALIC, BOLD, I_LINK_OPEN, I_LINK_SEPARATOR, I_LINK_CLOSE, E_LINK_OPEN,
	E_LINK_SEPARATOR, E_LINK_CLOSE, HTTP, REDIRECT, HEAD1, HEAD2, HEAD3,
	HEAD4, HEAD5, REF_OPEN, REF_SEPARATOR, REF_CLOSE, REF_LIST, BULLET_LIST_ITEM,
	NUMBERED_LIST_ITEM, INDENTING_ITEM, IMAGE_OPEN, IMAGE_CLOSE, IMAGE_SEPARATOR,
	IMAGE_ALT, TEXT} tokens;


typedef enum{FALSE, TRUE} boolean;

void printReferences();
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


