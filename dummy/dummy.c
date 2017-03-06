#include "../io/console.h"

void cls() {
	outp(254, 0); // border 0
	memset(0x5800, 7, 768); // color 7, bgcolor 0
}

void dummy1() {
	unsigned char f = 1;
	cls();
	while (1) {
		memset(0x4800, f, 0x800);
		f++;
	}
}

void dummy2() {
	unsigned long* clock = 0x5B04;
    unsigned long* onscreen = 0x5020;
    puts("Aquavitale");
    while (1) {
    	*onscreen = *clock;
    }
}
