# Exfil

A hybrid challenge, where a 8085 board is exfiltrating data using a led connected to its only output pin, serial data out.

The challenge is split into a 8085 binary provided to the contestants; which doesn't contain the flag but which can be used
to figure out the transmission encoding, and a live board from where the contestants can observe the blinking led.

The board with the led requires approx 15x15cm of table space and a power outlet. It should be placed in some decently visible location.

## Description

Before our previous agent was captured by KIA they managed to install our sophisticated malware into vital Kouvosto Telecom system to exfiltrate some data. Unfortunately the agent didn't have time to inform us about the encoding used, but they left us a test version of the binary. We believe you are able to observe the exfiltration process yourself and hopefully recover the vital secrets.

## Difficulty

Medium-ish, will require using a phone to record the led and then transcribing the data somehow to be processed. The encoding used is quite simple and might even be figured out without looking at the binary itself.

## Walkthrough

The transmission format is as follows, data is sent as 7 bit ASCII, MSB first:
1. Initialize the led to off
2. Start trasmitting from the begining of the flag
3. Read a character
4. If zero, goto 1
5. Shift the character left
6. Loop 7 times
   1. Rotate the character left, placing MSB in carry flag
   2. If carry, toggle the led state
   3. Wait for a while
   4. Toggle the led
   5. Wait for a while
7. Increment read pointer
8. Goto 3

This results in a transmission where a bit length is two transmission clock cycles, a 1 bit has a signal transition on both clock edges, a 0 bit only transitions on the second clock.
Thus same state held for 2 clocks means a 0 was transmitted and two consecutive short states is a 1


## Files

* challenge.bin - the sanitized binary
* challenge.asm - the code for the sanitized challenge binary
* source.asm - the code which will be running on the exfiltration board
* source.hex - the binary with the secrets in it, in intel hex format


## Flags

* DISOBEY[all you need is single output to exfiltrate data]

