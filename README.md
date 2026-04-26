## What is CFlat?

CFlat is a modern **C dialect** that enhances the C language with:

- **RAII (Resource Acquisition Is Initialization)**  
- **Automatic cleanup and resource management**  
- **Safer memory patterns**  
- **Cleaner syntax for common operations**  
- **Optional modern features without sacrificing C’s performance**

CFlat stays close to C’s design philosophy while smoothing out many of its rough edges.

---

## CFlat Example

**main.cf**

```c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <cflib.h>

#macro vec2(T)
typedef struct {
    T x;
    T y;
} vec2_##T ;
#endm

void my_free(void *tr) {
    free(tr);
}

vec2(int)

int main()
@{
    vec2_int vec;
    vec.x = 5;
    vec.y = 3;

    i32 *buffer = malloc(sizeof(i32));
    mfcu(my_free, buffer);

    {
        printf("welcome to cflat\n");
    }

    *buffer = 3;

    return 0;
    printf("hello0");
}
```

## **how to  compile  the example **
cfc -f main.cf -o  main


## ** how to install ** 

 download the installer script from the repo and run it
