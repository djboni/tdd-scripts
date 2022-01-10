# Building With build.mk

## Building an Executable

To build an executable, just run `build.mk` with the command `make`.

```sh
make -f script/build.mk

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj/main.o
# gcc build/obj/main.o -o build/main.elf
```

## Building an Archive/Library

To build an archive (aka. library), you need to provide the archive name so the
script knows you want that an not an executable. The default archive name is
`build/main.a`.

```sh
make -f script/build.mk build/main.a

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj/main.o
# ar -cq build/main.a build/obj/main.o
```

# Options/Variables of build.mk

## Variable EXEC="FILEPATH"

To change the executable path use the `EXEC` variable.

```sh
make -f script/build.mk EXEC="build/exec.elf"

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj/main.o
# gcc build/obj/main.o -o build/exec.elf
```

## Variable ARCHIVE="FILEPATH"

To change the archive path use the `ARCHIVE` variable. It is not enough to
provide the variable, you also need to pass the name of the archive file.

```sh
make -f script/build.mk ARCHIVE="build/lib.a" build/lib.a

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj/main.o
# ar -cq build/lib.a build/obj/main.o
```

## OBJ_DIR="DIRPATH"

To change the object files directory use the `OBJ_DIR` variable.

```sh
make -f script/build.mk OBJ_DIR="build/obj_c"

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj_c/main.o
# gcc build/obj_c/main.o -o build/main.elf
```

## INPUTS="FILEPATH ..."

Use the variable `INPUTS` to choose the files you want to compile.
Example: `INPTUS="main.c"`.

For more than one file, separate them with spaces.
Example: `INPTUS="main.c add.c sub.c"`.

```sh
make -f script/build.mk INPUTS="main.c"

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj/main.o
# gcc build/obj/main.o -o build/main.elf
```

# Compile Options

You can set several compilation options:

| VARIABLE | DESCRIPTION           |
| -------- | --------------------- |
| CC       | C compiler            |
| CFLAGS   | C compiler flags      |
| CPPFLAGS | C pre-processor flags |
| LDFLAGS  | Linker flags          |
| LDLIBS   | Liked libraries       |
| AR       | Archiver              |
| ARFLAGS  | Archiver flags        |
