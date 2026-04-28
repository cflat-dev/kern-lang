### KernC flags


| Flag    | Description                                                   | Example                               |
|---------|---------------------------------------------------------------|----------------------------------------|
| -f      | All arguments until the next flag are treated as input files  | `kernc -f file1.cf file2.cf`             |
| -o      | The next argument is the output file                          | `kernc -o outputfile`                    |
| -i      | All arguments until the next flag are include directories     | `kernc -i include/ libs/`                |
| -l      | All arguments until the next flag are libraries to link       | `kernc -l sdl2`                          |
| -ldir   | All arguments until the next flag are library search paths    | `kernc -ldir /usr/local/bin/`            |
| -shared | Marks the output file as a shared library                     | `kernc -f test.cf -o test.so -shared`    |
| -app    | All arguments until the next flag are preprocesser addons     |  `kernc -app  my_addon.lua`               |


### Syntax

# the raii blocks 

a raii block is written as
```c 

@{
    // code here
}

```

to register a variable for cleanup you use the mfcu function
```c

mfcu( cleanup function , variable pointer )

```

the cleanup function signture  must be exactly
void (void *)


to release a variable from cleanup call

```c
release(variable ptr) 
```

the variables within the raii scope will be cleaned up in reverse order of registering (LIFO ordering)

**note that to return a variable that has been marked for cleanup you must call release  ***


#  the  macro directive 


the macro directive is a more  readable way of doing  multi‑line #define`s

the macro directive is used as :
```c

#macro name ( parms ) 

/*  your block here  */

#endm




```

\#arg  converts the arg  to a string
example:
```c
 #macro string (name,value)

const char * name  = #value
 #endm

```

\## just like in C it concats two params togather 

```c

#macro  concat(a,b)

 a##b

#endm

```


**standard library**
Currently there is no standard library.
Soon It will be added to a future release (coming soon)
