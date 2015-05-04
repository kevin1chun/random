#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <time.h>
#include "counters.h"


int main(int argc, char *argv[]) {

	hwCounter_t  c1;
	c1.init = false;
	initTicks(c1);

	uint64_t current_time = getTicks(c1);
	printf("Current time in Ticks  %lu\n", current_time);


}