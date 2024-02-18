# Blind Challenge

A 8085 binary. The binary outputs a flag string to a hitachi compatible 2x16 character LCD using custom glyphs. The ST7066U is a hint to the LCD controller for its datasheet. The initialization commands should be easy to recognize, as it is just a bog-standard hitachi protocol lcd controller. Tested on real hardware.

## Description

We have obtained a kouvosto telecom binary from their latest state-of-the-art 8085 system. The documentation refers to some smuggled in ST7066U cryptographic processors. We need to figure out their vital secrets.

## Difficulty

The challenge mainly just involves reading the datasheet and then figuring out the custom character bitmaps. Shouldn't be too hard.

## Flags:

* DISOBEY(custom characters rule)

## Files

* source.hex - intel hex formatted challenge binary

* source.asm - assembler code for the challenge binary, compile with ASL
* source.lst - listing of the source code
* source.p - ASL object file of the challenge binary

## Solving

0. Read the datasheet for the LCD controller
1. Load the binary into ghidra
2. Figure out that LCD command register is 0x20 and data register 0x21
3. See that the CGRAM is filled 64 bytes from 0x00B3 onwards
4. Draw the bitmaps, get characters c, u, s, t, o, m, h and a
5. See that the LCD display is filled with strings from 0x00F3 and 0x0102
6. Decipher the strings with the earlier custom character bitmaps
