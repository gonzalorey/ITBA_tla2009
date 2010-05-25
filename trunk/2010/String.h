/* String.h  */

#ifndef STRING_H_
#define STRING_H_

typedef char *string_t;

char *newString(string_t str);

int StringContainsChar(string_t str, char c);

int StringLength(string_t str);

char *StringAppendChar(string_t *str, char c);

void FreeString(string_t str);

#endif /* STRING_H_ */
