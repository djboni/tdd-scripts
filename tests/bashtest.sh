#!/bin/bash
# Copyright (c) 2022 Djones A. Boni - MIT License

f_bashtest_start() {
    NumTests=0
    NumFails=0

    # Discard stdout
    exec >/dev/null
}

f_bashtest_end() {
    echo "---------------------------------------" >&2
    echo "TestsFailed=$NumFails" >&2
    
    if [ $NumFails -eq 0 ]; then
        echo -e "OK\n" >&2
        exit 0
    else
        echo -e "FAIL\n" >&2
        exit 1
    fi
}

f_error() {
    # Usage: f_error "MESSAGE"
    # echo FILE:LINE: TEST: MESSAGE
    echo "${BASH_SOURCE[2]}:${BASH_LINENO[1]}: ${FUNCNAME[2]}:" "$@" >&2
    NumFails=$((NumFails + 1))
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

f_assert_equal() {
    if [ $# -eq 2 ]; then
        Expected=$1
        Actual=$2
    else
        f_error "Error Usage: f_assert_equal Expected Actual"
    fi

    if [ "$Expected" != "$Actual" ]; then
        f_error "
Expected=\"$Expected\"
Actual=\"$Actual\""
    fi
}
