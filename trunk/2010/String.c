/* String.c */

#include "String.h"
#include <string.h>
#include <stdlib.h>

string_t newString(char *str){
	string_t ret;

	if((ret = malloc(StringLength(str) + 1)) == NULL)
		return NULL;

	strcpy((char *) ret, str);

	return ret;

}


int StringContainsChar(string_t str, char c){

	char *s = (char *)str;

	while(*s != '\0'){
		if(*s == c)
			return 1;

		s++;
	}

	return 0;
}

char *StringAppendChar(string_t *str, char c){

	char *newString;

	int length = StringLength(*str);

	if((newString = malloc(length + 2)) == NULL){
		return NULL;
	}

	strcpy(newString, *str);

	newString[length] = c;
	newString[length + 1] = '\0';

	FreeString(*str);

	*str = newString;

	return *str;

}

int StringLength(string_t str){
	return strlen(str);
}

void FreeString(string_t str){
	free(str);
}
