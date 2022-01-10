#!/bin/bash
# Copyright (c) 2022 Djones A. Boni - MIT License

source bashtest.sh

f_bashtest_start

f_build_mk_GivenAObjectTarget_ThenShouldCreateObjectFromCFile() {
    # Set-up
    Base=file
    f_create_file $Base.c "int main(void) { return 0; }"

    # Execution
    make -f ../build.mk $Base.o

    # Assertions
    f_assert_file_exists $Base.o

    # Tear-down
    f_delete_files $Base.c $Base.o
}
f_build_mk_GivenAObjectTarget_ThenShouldCreateObjectFromCFile

f_build_mk_GivenAObjectTargetWithObjDir_ThenShouldCreateObjectFromCFile() {
    # Set-up
    Base=file
    f_create_file $Base.c "int main(void) { return 0; }"

    # Execution
    make -f ../build.mk obj/$Base.o OBJ_DIR=obj

    # Assertion
    f_assert_file_exists obj/$Base.o

    # Tear-down
    f_delete_files $Base.c obj/$Base.o
    f_delete_dirs obj
}
f_build_mk_GivenAObjectTargetWithObjDir_ThenShouldCreateObjectFromCFile

f_build_mk_GivenAnArchiveTarget_ThenShouldCreateAnArchiveFromInputFiles() {
    # Set-up
    Base=archive
    f_create_file add.c "int add(int a, int b) { return a + b; }"
    f_create_file sub.c "int sub(int a, int b) { return a - b; }"

    # Execution
    make -f ../build.mk $Base.a ARCHIVE=$Base.a OBJ_DIR=obj INPUTS="add.c sub.c"

    # Assertions
    f_assert_file_exists $Base.a
    f_assert_file_exists obj/add.o
    f_assert_file_exists obj/sub.o

    # Tear-down
    f_delete_files add.c sub.c obj/add.o obj/sub.o $Base.a
    f_delete_dirs obj
}
f_build_mk_GivenAnArchiveTarget_ThenShouldCreateAnArchiveFromInputFiles

f_build_mk_GivenAnExecTarget_ThenShouldCreateAnExecFromInputFiles() {
    # Set-up
    Base=exec
    f_create_file add.c "int add(int a, int b) { return a + b; }"
    f_create_file main.c "int main(void) { return 0; }"

    # Execution
    make -f ../build.mk $Base.elf EXEC=$Base.elf OBJ_DIR=obj \
        INPUTS="add.c main.c"

    # Assertions
    f_assert_file_exists $Base.elf
    f_assert_file_exists obj/add.o
    f_assert_file_exists obj/main.o

    # Tear-down
    f_delete_files add.c main.c obj/add.o obj/main.o $Base.elf
    f_delete_dirs obj
}
f_build_mk_GivenAnExecTarget_ThenShouldCreateAnExecFromInputFiles

f_build_mk_GivenAnExecTarget_WhenTheInputFileIsAbsolute_ThenShouldUseAbsolutePathPrependedWithObjectPath() {
    # Set-up
    Base=exec
    f_create_file main.c "int main(void) { return 0; }"

    # Execution
    make -f ../build.mk $Base.elf EXEC=$Base.elf OBJ_DIR=obj \
        INPUTS="$PWD/main.c"

    # Assertions
    f_assert_file_exists $Base.elf
    f_assert_file_exists obj/$PWD/main.o

    # Tear-down
    f_delete_files main.c obj/$PWD/main.o $Base.elf
    f_delete_dirs --parents obj/$PWD
}
f_build_mk_GivenAnExecTarget_WhenTheInputFileIsAbsolute_ThenShouldUseAbsolutePathPrependedWithObjectPath

f_build_mk_GivenAnExecTarget_WhenTheInputFileHasParentReference_ThenShouldRemoveParentFromObjectPath() {
    # You need to provide the variable VPATH with a semicolon-separated list of
    # the parents used.
    # Example 1: INPUTS="../main.c" needs VPATH=..
    # Example 2: INPUTS="../../main.c" needs VPATH=../..
    # Example 3: INPUTS="../main.c ../../add.c" needs VPATH=..:../..

    # Set-up
    Base=exec
    f_create_dir dir
    f_create_file main.c "int main(void) { return 0; }"

    # Execution
    make -C dir -f ../../build.mk $Base.elf EXEC=$Base.elf OBJ_DIR=obj \
        INPUTS="../main.c" VPATH=..

    # Assertions
    f_assert_file_exists dir/$Base.elf
    f_assert_file_exists dir/obj/main.o

    # Tear-down
    f_delete_files main.c dir/obj/main.o dir/$Base.elf
    f_delete_dirs dir/obj
    f_delete_dirs dir
}
f_build_mk_GivenAnExecTarget_WhenTheInputFileHasParentReference_ThenShouldRemoveParentFromObjectPath

f_bashtest_end
