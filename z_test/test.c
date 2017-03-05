#include "stdio.h"

void* get(void* param, void* param2) {
	return 5 + param + param2;
}

void* get2() {
	return get(5, 7);
}

unsigned char  cs(unsigned char pnum) {
	get2();
	return pnum;
}

void dummy2() {
    int i;
    char* str = 0x9100;
    sprintf(str, "Aquavitale %d", 79);
    for (i = 0; i < 100; i++) {
        if (*(str + i) == 0) break;
        putc(*(str+i));
    }
}

void empty() {
	cs(9);
}
