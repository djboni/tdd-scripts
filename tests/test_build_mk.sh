#!/bin/bash
# Copyright (c) 2022 Djones A. Boni - MIT License

# Discard stdout
exec >/dev/null

f_error() {
    # Usage: f_error "MESSAGE"
    # echo FILE:LINE: TEST: MESSAGE
    echo "${BASH_SOURCE[1]}:${BASH_LINENO[1]}: ${FUNCNAME[2]}:" "$@" >&2
}

f_create_file() {
    if [ $# -eq 2 ]; then
        FileName="$1"
        FileContent="$2"
    else
        f_error "Usage: f_create_file FileName FileContent"
        exit 1
    fi

    echo "$FileContent" >"$FileName"
}

f_delete_files() {
    if [ $# -eq 0 ]; then
        f_error "Usage: f_delete_files FileNames ..."
        exit 1
    fi

    rm "$@"
}

f_create_dir() {
    if [ $# -eq 1 ]; then
        DirName="$1"
    else
        f_error "Usage: f_create_dir DirName"
        exit 1
    fi

    mkdir "$DirName"
}

f_delete_dirs() {
    if [ $# -eq 0 ]; then
        f_error "Usage: f_delete_dirs DirNames ..."
        exit 1
    fi

    rmdir "$@"
}

f_assert_file_exists() {
    if [ $# -eq 0 ]; then
        FileName="file.c"
    elif [ $# -eq 1 ]; then
        FileName="$1"
    elif [ $# -eq 2 ]; then
        FileName="$1"
    else
        f_error "Error Usage: f_delete_file [FileName]"
    fi

    if [ ! -f $FileName ]; then
        f_error "File '$FileName' does not exist"
    fi
}

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
