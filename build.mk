# Copyright (c) 2022 Djones A. Boni - MIT License

EXEC = build/main.elf
ARCHIVE = build/main.a
OBJ_DIR = build/obj
INPUTS = $(wildcard *.c)

CC = gcc
CFLAGS = -g -O0 -std=c90 -pedantic -Wall -Wextra -Werror
CPPFLAGS =
LDFLAGS =
LDLIBS =

AR = ar
ARFLAGS = -cq

INPUTS_NO_PARENT = $(subst ../,,$(INPUTS))
OBJECTS = $(patsubst %.c,$(OBJ_DIR)/%.o,$(INPUTS_NO_PARENT))

all: $(EXEC)

$(OBJ_DIR)/%.o: %.c
	@X="$@"; if [ "$${X%/*}" != "$$X" ]; then mkdir -p "$${X%/*}"; fi
	$(CC) $(CFLAGS) $(CPPFLAGS) $< -c -o $@

$(EXEC): $(OBJECTS)
	@X="$@"; if [ "$${X%/*}" != "$$X" ]; then mkdir -p "$${X%/*}"; fi
	$(CC) $^ -o $@ $(LDFLAGS) $(LDLIBS)

$(ARCHIVE): $(OBJECTS)
	@X="$@"; if [ "$${X%/*}" != "$$X" ]; then mkdir -p "$${X%/*}"; fi
	$(AR) $(ARFLAGS) $@ $^
