# Undocumented challenge

This is a 8085 binary, load address 0x8000. The challenge uses few so called "undocumented" 8085 instructions, that are currently quite well documented for obfuscation. The binary has been tested on real hardware.

## Description

8085 0x8000 otherwise undocumented

## Difficulty

Apart from the few undocumented, and unsupported by ghidra, instructions there shouldn't be anything too complicated in the code. Probably on the medium scale, as the challenge name and description tries to hint that there might be something outside the vendor documentaiton going on.

## Walkthrough

1. The code does initial initialization; disables interrupts, sets the stack pointer
2. With an undocumented instruction (see for example http://john.ccac.rwth-aachen.de:8000/as/as_EN.html#ref_8085Spec for documentation)
   we set a new pre-populated stack pointer
3. Use ret with the new stack to jump to the two part flag decryption routine
4. The flag is decrypted using addition modulo 256 and output to the UART

## Files

* source.bin - challenge binary
* source.asm - assembler souces, compiles with http://john.ccac.rwth-aachen.de:8000/as/
* source.hex - intel hex format for use in testing
* source.p - AS "object file"

## Flags

* DISOBEY[sometimes vendors don't tell about all of the features!]
