# Bug free challenge

Inte 8051 binary. This is a challenge that is born from ghidra decompiler bug #6074.
The bug means that ADC A, @R0 instruction handling in ghidra refereces the wrong
memory region and thus the carry is handled improperly and ghidra thinks some
conditional branches will never be taken.

The code has been tested on a real 8051 hardware.

## Description

Intel 8051. Beware of bugs.

## Difficulty

If one reads the assembly it shouldn't be too hard to figure out, if relying
on the ghidra's decompiler output only one will miss two alterations to
decryption parameters and thus be unnable to get the key.

The code is probably also executable on a 8051 emulator, but I haven't tried that
route.

## Walkthrough

1. Load the code into ghidra
2. Dissassemble from 0
3. FUN_CODE_007b is the serial init
4. FUN_CODE_001e sets intmem 24 to 0x9f, it is an offset to the start of the key block
5. FUN_CODE_002e sets intmem 25 to 2, number of bytes to skip from the key per decrypted character
6. FUN_CODE_003f is the decryption routine
  1. It copies the encrypted flag into intmem, starting from 0x40
  2. It takes bytes starting from address stored in intmem 23 and 24 and does xor with the encrypted key
  3. It skips bytes based on intmem 25
  4. once the flag is decrypted it outputs it to serial

## Files

* challenge.hex - intel hex formated challenge binary for distribution

* challenge.asm - assembly source code for the challenge, use http://john.ccac.rwth-aachen.de:8000/as/ to compile
* p80c51fa.inc - special function register definitions for the development hardware

## FLAGS

* DISOBEY[gh1Dr4 bUg 6074]
