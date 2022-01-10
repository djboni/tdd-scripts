# [TDD Scripts](https://github.com/djboni/tdd-scripts)

Copyright (c) 2022 Djones A. Boni

**TDD Scripts** helps you to build and to test your project.

One day I was configuring and organizing the builds of one CI/CD pipeline and
I figured there were too many hard do maintain duplicated scripts. After a few
attempts to organize that mess I decided to extract the recurring scripts into
some dedicated files and create tests for them.

You are free to copy, modify, and distribute **TDD Scripts** with attribution
under the terms of the MIT license. See the LICENSE file for details.

# Using TDD Scripts in Your Project

To use **TDD Scripts** in your project you can:

- Copy some of the scripts into your project; or
- Add **TDD Scripts** as a submodule.

```sh
git submodule add https://github.com/djboni/tdd-scripts.git script
```

# Building C files

To build C files, run `make` and provide the path to `build.mk`.
For more information see
[Building With build.mk](https://github.com/djboni/tdd-scripts/blob/master/doc/build-mk.md).

This compiles all C source files in the current directory into object files and
link them into an executable file.

```sh
make -f script/build.mk

# Output:
# gcc -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror main.c -c -o build/obj/main.o
# gcc build/obj/main.o -o build/main.elf
```

Executables and object files are organized inside the `build` directory, so it
is easy to clean things up.

Run the created executable.

```sh
./build/main.elf

# Output:
# Hello world!
```

Example of `main.c` file that creates this output.

```c
/* main.c */

#include <stdio.h>

int main(void)
{
    printf("Hello world!\n");
    return 0;
}
```

# Merge Coverage XML Files

You can merge several coverage XML files into one using the script using
`merge_cov_xml.py`.

```sh
# C/C++ coverage
gcovr --xml-pretty -o cov_c.xml

# Python coverage
coverage xml -o cov_py.xml

# Merge coverage XML files
python3 merge_cov_xml.py cov_*.xml > cov.xml
```
