#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdio.h>

#define ARROW_TAG "<img alt=\"Redirect arrow without text.svg\" src=\"http://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Redirect_arrow_without_text.svg/30px-Redirect_arrow_without_text.svg.png\" width=\"30\" height=\"13\">"


void matchItalic(char *text, FILE * out);
void matchBold(char *text, FILE * out);
void matchBoldItalic(char * text, FILE *out);
void matchHeading(char *text, FILE *out);
void matchIndent(char *text, FILE *out);
void matchRedirect(char *text, FILE *out);
void matchExtLink(char * link, char * text, FILE *out);

#endif /* MATCHFUNCTION_H_ */


