#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#include "../include/mfcu.h"

void my_clean(void *ptr)
{
    printf("freeing %p\n", ptr);
    free(ptr);
}

typedef struct
{
    char *data;
    size_t size;
    size_t len;
}  str_t;

str_t str_create(const char *text)
{
    str_t s;
    s.data = strdup(text);
    s.len = strlen(text);
    s.size = s.len + 1;
    return s;
}
void str_destroy(str_t *s)
{
    free(s->data);
    s->data = NULL;
    s->size = 0;
    s->len = 0;
}
void str_free(void *ptr)
{
    printf("destroying %p\n", ptr);
    str_t* t = (str_t*)ptr;
    str_destroy(t);
}

void str_sprintf(str_t *string ,const char *fmt, ...) {
    va_list args;

    // 1. Calculate length
    va_start(args, fmt);
    int len = vsnprintf(NULL, 0, fmt, args); // Standard C99 behavior
    va_end(args);

    if (len < 0) return ; // Handle encoding errors

    // 2. Allocate
    char *str = malloc(len + 1);
    if (!str) return ;

    // 3. Write
    va_start(args, fmt); // Must restart va_list to read it again
    vsnprintf(str, len + 1, fmt, args);
    va_end(args);

  str_free(string);

    string->data = str;  string->len = len; string->size = len + 1;

}


#define str_cstr(str) str->data

#define str_new(name, tex) \
str_t name = str_create(tex); \
mfcu(str_free, &name); // Added & here


#define array(type, name, size) \
type* name = malloc(sizeof(type) * size); \
mfcu(my_clean, name)



int main(void)
{
    raii_scope;

str_new(hello,  "hello");

 str_sprintf(&hello,"%s","hello");

printf("%s",hello.data);


array(int,t,100000);



    ret(0);
}