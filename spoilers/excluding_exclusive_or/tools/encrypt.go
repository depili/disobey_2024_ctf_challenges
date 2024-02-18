package main

import (
	"fmt"
	"math/rand"
)

func main() {
	plain := " _  __                          _          _____    _\n"
	plain += "| |/ /___  _   ___   _____  ___| |_ ___   |_   _|__| | ___  ___ ___  _ __ ___\n"
	plain += "| ' // _ \\| | | \\ \\ / / _ \\/ __| __/ _ \\    | |/ _ \\ |/ _ \\/ __/ _ \\| '_ ` _ \\\n"
	plain += "| . \\ (_) | |_| |\\ V / (_) \\__ \\ || (_) |   | |  __/ |  __/ (_| (_) | | | | | |\n"
	plain += "|_|\\_\\___/ \\__,_| \\_/ \\___/|___/\\__\\___/    |_|\\___|_|\\___|\\___\\___/|_| |_| |_|\n"
	plain += "\n"

	out := make([]byte, 2*len(plain))

	for i, c := range plain {
		rnd := byte(rand.Int() % 256)
		if rnd == 42 {
			rnd = 47
		}
		out[i*2] = rnd
		out[(i*2)+1] = byte(c) - rnd
	}

	fmt.Printf("Obfuscated:")
	for i, c := range out {
		if i%16 == 0 {
			fmt.Printf("\n\t\tDB ")
		}
		fmt.Printf("0%0.2xh, ", c)
	}

	plain2 := "Do not provide the password to Ahven!\nDISOBEY[ahven is for lame skript kiddies]\n"

	out2 := make([]byte, 2*len(plain2))

	for i, c := range plain2 {
		rnd := byte(rand.Int() % 256)
		if rnd == 0x42 {
			rnd = 47
		}
		out2[i*2] = rnd
		out2[(i*2)+1] = byte(c) - rnd
	}

	fmt.Printf("\n\nSecond Obfuscated:")
	for i, c := range out2 {
		if i%16 == 0 {
			fmt.Printf("\n\t\tDB ")
		}
		fmt.Printf("0%0.2xh, ", c)
	}
}
