# Excluding exclusive or

A intel 8085 binary that outputs the flag to a 8251A UART. Not too heavily obfuscated, mainly the data is interleaved with the code to make dissassembling it non-trivial. Load address of the binary is also 0x8000, can be deduced from the jumps or can be given as starting information.

## Description

Ahven has obtained a piece of secure Kouvosto Telecom software. As far as we can tell it is running on the latest intel 8085 processor and does some UART communications.

## Files

* source.bin - challenge binary
* source.asm - assembler sources of the challenge binary, compile with http://john.ccac.rwth-aachen.de:8000/as/
* source.hex - intel hex of the challenge, used for verification on real hardware
* source.lst - listing file for the compiled binary
* tools/encrypt.go - a tool for the obfuscated strings computation

## Difficulty

Probably medium or hard, as it uses slightly obscure platform. Can be made easier if the contestants remember something from Z80 challenges last year and realize that 8085 code is compatible with Z80, as that code is easier to read.

## Flag

* DISOBEY[ahven is for lame skript kiddies]

## Walkthrough

* The binary first sets up the stack and UART, and then calls the first de-encryption routine.
* The de-encryption takes the return address from the stack and starts reading data from there
* First the byte read is checked for the EOF marker, 42, and if matches return to the next address
* The first read byte is added modulo 256 to the next read byte
* The result is output to the uart
* After the first block is done then the binary contains little more code and a second block
* This second block is otherwise identical but the EOF marker is 0x42
* The second block contains the flag

### Screenshot
```
MON85 Version 1.2

Copyright 1979-2007 Dave Dunfield
2012 Roman Borik
All rights reserved.

C> l
C> g 8000
 _  __                          _          _____    _
| |/ /___  _   ___   _____  ___| |_ ___   |_   _|__| | ___  ___ ___  _ __ ___
| ' // _ \| | | \ \ / / _ \/ __| __/ _ \    | |/ _ \ |/ _ \/ __/ _ \| '_ ` _ \
| . \ (_) | |_| |\ V / (_) \__ \ || (_) |   | |  __/ |  __/ (_| (_) | | | | | |
|_|\_\___/ \__,_| \_/ \___/|___/\__\___/    |_|\___|_|\___|\___\___/|_| |_| |_|

Do not provide the password to Ahven!
DISOBEY[ahven is for lame skript kiddies]
BC=0000  DE=0000  HL=83AB  SP=C000  PC=83AB   PSW=4254   FLAGS=-Z-A-P--
C>
```