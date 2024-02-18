# Secure Unique Cryptographic Key System (SUCKS)

This is a multifail of a 8085 code. The challenge has 3 flags, which can be obtained by different ways:
* There is a non-constant time password prompt, valid pw gets a flag with a timing side channel
* The password entry has a buffer overrun into the stack, overwriting the return pointer gets another flag
* The overrun can be also used for code execution, with that the 3rd flag can be obtained

Implementing the latter exploits can be also used to retrieve the flags from earlier stages.

The challenge will consist of a binary with redacted secrets and 2-4 of PCBs actually running the real challenge code with USB UART adapters.

The boards will preferably be at a table next to the CTF desk, and they require one power outlet each. Alternatively they can be loaned out to contestants.

## Descriptions

We have obtained from Kouvosto Telecom a binary from development version of a secure unique cryptographic key system and few production devices. Can you obtain the secrets from within?

Devices are near the CTF desk. Please press the reset button after you are done.

There are 4 flags, with one of them being hidden in unknown location. Good luck.

## Walkthroughs
### flag1: Timing attack

The login routine has "WITH MILITARY GRADE ANTI BRUTE FORCE SECURITY" which means that after each correctly matched character in a PW a delay loop will be ran. This allows for quite easy timing attack to brute force the password one character at a time.

The included brute forcer is able to get the PW in a minute, as long as the chosen brute force character set starts with lower case letters
this timing should hold. The PW is 'teddybear'

`tools/timing/exploit.go` is an example exploit.

I expect that this flag might be accessible even without doing any binary reverse engineering.

### flag2: Buffer overflow to return address override

The PW length check looks for null terminated string, and if it is longer than 32 character it errors out. The input buffer is in memory at 0xBF00, stack starts at 0xC000. The dissassembly gives us a ready address for printing the flag2 at 0x0140. So writing a "password" in the form of: 0,0, 0x01, 0x40, 0x01, 0x40.... with for example length of 1024 bytes will override the whole stack and give us the second flag.

`tools/stack/exploit2.go` is an example exploit

### flag3: Buffer overflow to RCE

We can include code in the PW buffer overflow, and then just corrupt the stack so that the return will jump to our own code. We want to execute:
```
	LXI flag3
	JMP PRINT_STRING
```

The needed bytes can be extracted from the compiled binary, LXI is 0x21 followed by the low byte of the address and then the high byte. JMP is 0xc3 followed by the low byte of the address and then the high byte.

This is demonstrated by `tools/rce/exploit3.go`

### flag4: Memory dump

The last flag is in an unknown location in the firmware. To extract it one needs to do little more 8085 coding, for example like demonstrated in `tools/memdump/source.asm` to either dump the whole memory out or hunt for the flags in the memory.

One doesn't need to be fancy and use hex unless one wants to, just a simple loop outputing the bytes to serial would also work, as the flags are in plain ASCII.

## Flags

* flag1: DISOBEY[Great timing there dude]
* flag2: DISOBEY[Oh, you could jump here?]
* flag3: DISOBEY[RCE is still the king baby!]
* flag4: DISOBEY[look at you hacker. How can you challenge a perfect, immortal machine?]

## Files

* hardware.jpeg - photo of the challenge hardware setup
* challenge.bin - The challenge binary without secrets
* challenge.lst - Listing of the challenge binary code
* challenge.asm - assembler code for the challenge binary
* challenge.bin - challenge binary without secrets
* development/source.asm - the 8085 assembler source, not redacted, running on the HW
* development/source.lst - compiled production code
* development/source.bin - Challenge binary running on the boards, with secrets
* development/testing.asm - version that loads at 0x8000 for testing with mon85
* tools/ example exploits written in go