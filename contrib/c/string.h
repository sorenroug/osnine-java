/*
 * Definitions of string functions.
 */

extern char *strcat();
extern char *strncat();
extern char *strcpy();
extern char *strhcpy();
extern char *strncpy();
extern char *index();
extern char *rindex();
extern int strcmp();
extern int strncmp();
extern int strlen();

#define strchr index
#define strrchr rindex
