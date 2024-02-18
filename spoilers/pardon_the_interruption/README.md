OBS, TYPO


# Pardon the interruption

Yet another 8085 binary. This time it is a quick introduction to interrupts. Also has one switch-case structure to decode.

The binary has been tested on real hardware, and in there the slow code also limits copy-pasting the flag in due to slow-ass compare code that will lose characters.

## Description

We interrupt your regulary scheduled CTF to bring you this 8085 binary

## Walkthrough

The binary initializes the 8251A UART and then proceeds to listen for new characters via interrupt RST 6.5. Characters are compared via
a jump table and correct flag input results in "CORRECT" getting output to the serial port.

The jump table compares the current character offset to positions where a given character should occur.

## Difficulty

This doesn't really use any fancy anti-ghidra tricks apart from the one jump table that will be decoded by ghidra just fine, so it should be on the easier side.

The use of a interrupt means that unless one sets the memory as volatile then the main loop decompilation will make no sense.

If one is able to run the code on an simulator it is also quite easy to brute force the flag, as it is checked character by character,
and a error is produced right away on a wrong character.

## Flag

* DISOBEY[INTERRUPTS AND SWITCH]

## Files

* source.bin - challenge binary
* source.asm - assembler source of the binary
* source.lst - listing of the assembled code
* source.p - "object file" from the assembler

