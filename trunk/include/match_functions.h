#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdio.h>
#include <time.h>

#define ARROW_TAG "<img alt=\"Redirect arrow without text.svg\" src=\"http://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Redirect_arrow_without_text.svg/30px-Redirect_arrow_without_text.svg.png\" width=\"30\" height=\"13\">"
#define MAX_LENGTH 150
#define TAG_LENGTH 10
#define REF_CANT   20
#define MAX_INDENT 50
#define USER_NAME "Tester"

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


typedef enum{FALSE, TRUE} boolean;

void printReferences();
void matchItalic(FILE * out);
void matchBold(FILE * out);
void matchBoldItalic(FILE *out);
void matchHeading(char *text, FILE *out, int cantEquals);
void matchRedirect(char *text, FILE *out);
void matchExtLink(char * link, char * text, FILE *out);
void matchInterLink(char *text, char * title, FILE *out);
void matchList(tList * ref, FILE *out);
void recursiveList(tList *ref,FILE *out,int index);
void matchSignature(int cant,FILE *out);
void matchImage(char * str, char * str2, char * str3, boolean isThumb, FILE * out);

#endif /* MATCHFUNCTION_H_ */


