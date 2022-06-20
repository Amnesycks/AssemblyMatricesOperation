# Makefile to build the project

# Flags to pass to GCC
CFLAGS = -g -Wall -Wextra -pedantic -std=c99

# Flags to pass to nasm
AFLAGS = -g -f elf64

PROG = asmfunctions
OBJECTS = main.o matrix_calc.o

# Default target - what gets built if you just run "make"
all: $(PROG)

# To make the executable, link all the objects together
$(PROG): $(OBJECTS)
	gcc $(CFLAGS) -o $(PROG) $(OBJECTS) -g

# To compile a C file, use GCC
%.o: %.c
	gcc $(CFLAGS) -c $<

# To compile an assembler file, use nasm
%.o: %.s
	nasm $(AFLAGS) $<

# Clean up compiled files
clean:
	rm -f $(PROG) $(OBJECTS)
