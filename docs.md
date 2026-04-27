### cfc flags


| Flag    | Description                                                   | Example                               |
|---------|---------------------------------------------------------------|----------------------------------------|
| -f      | All arguments until the next flag are treated as input files  | `cfc -f file1.cf file2.cf`             |
| -o      | The next argument is the output file                          | `cfc -o outputfile`                    |
| -i      | All arguments until the next flag are include directories     | `cfc -i include/ libs/`                |
| -l      | All arguments until the next flag are libraries to link       | `cfc -l sdl2`                          |
| -ldir   | All arguments until the next flag are library search paths    | `cfc -ldir /usr/local/bin/`            |
| -shared | Marks the output file as a shared library                     | `cfc -f test.cf -o test.so -shared`    |
| -app    | All arguments until the next flag are preprocesser addons     |  `cfc -app  my_addon.lua               |