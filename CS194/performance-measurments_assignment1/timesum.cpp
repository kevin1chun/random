#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <time.h>
#include "counters.h"

int timedsumPrint(int n) {
	long long sum = 0;

	hwCounter_t  c1;
	c1.init = false;
	initTicks(c1);

	uint64_t t1;
	uint64_t t2;

	
	t1 = getTicks(c1);
	for(long long i = 0; i < n; i++) {
		sum += i;		
	}
	t2 = getTicks(c1);
	printf("Sum Result %llu  took %d \n", sum, (int) (t2 - t1)); //%llu 
}

int main(int argc, char *argv[]) {

	int n = 10000;
	timedsumPrint(n);

	
}