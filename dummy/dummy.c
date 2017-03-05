
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
    int i;
    char* str = 0x9100;
    sprintf(str, "Aquavitale %d", 79);
    for (i = 0; i < 100; i++) {
        if (*(str + i) == 0) break;
        putc(*(str+i));
    }
}
