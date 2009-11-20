#ifndef MATCHFUNCTION_H_
#define MATCHFUNCTION_H_

#include <stdlib.h>
#include <stdio.h>

#define MAX_LENGTH 20

void matchItalic(char *str, int length, FILE *in, FILE *out);

void matchBold(char *str, int length, FILE *in, FILE *out);

void matchHeading(char *text, FILE *out);

void matchBoldItalic(char *str, int length,FILE *in, FILE *out);

#endif /* MATCHFUNCTION_H_ */
