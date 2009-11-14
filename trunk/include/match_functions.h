#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdio.h>

void matchItalic(char *text, FILE * out);
void matchBold(char *text, FILE * out);
void matchBoldItalic(char * text, FILE *out);
void matchHeading(char *text, FILE *out);
void matchExtLink(char * text, FILE *out);

#endif /* MATCHFUNCTION_H_ */


