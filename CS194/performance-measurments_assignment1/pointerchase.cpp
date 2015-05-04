#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <time.h>
#include "counters.h"

int main(int argc, char *argv[]) {
	int numberTests = 1000;
	double tests[numberTests];
	srand(time(NULL));
	hwCounter_t  c1;
	c1.init = false;
	initTicks(c1);

	uint64_t t1;
	uint64_t t2;

	int N  = atoi(argv[1]) / 4;

	int a[N];

	for (int k = 0; k < numberTests; k++) {

		for (int i = 0; i < N; i++) { //inside-out Fisher-yates
			int randPos = rand() % (i+1);
			a[i] = a[randPos];
			a[randPos] = i;
		}

		int current = 0;

		for (unsigned int i = 0; i < N * 10; i++) { //warm up
			current = a[current];
		}

		t1 = getTicks(c1);
		for (unsigned int i = 0; i < 1048576; i++) { //let's chase!
			current = a[current];
		}
		t2 = getTicks(c1);

		int totalCycles = (int) (t2 - t1);
		double avgCyclesPerLoad = totalCycles / (double) 1048576;

//		printf("Chasing ended at %d. \tTook %d ticks\tcycles/load = %f\tcache size = %lu\n", current,  totalCycles, avgCyclesPerLoad , sizeof(a)); 
		printf("%d,", current); 

		tests[k] = avgCyclesPerLoad;
	}

	double endTotal = 0;
	for(int i = 0; i < numberTests; i++) {
		endTotal += tests[i];

	}
	printf("\n----------------------\nCachsize = %lu	\n", sizeof(a)); 

	printf("Result = %f\n", endTotal / numberTests); 

}