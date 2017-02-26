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


void empty() {
	cs(9);
}
