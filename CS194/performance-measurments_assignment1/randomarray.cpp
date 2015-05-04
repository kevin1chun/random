#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <time.h>
#include "counters.h"

int main(int argc, char *argv[]) {
	srand(time(NULL));

	int n = rand() % 10;

	int N = 20;

	int a[N];

	for (int i = 0; i < N; i++) { //inside-out Fisher-yates
		int randPos = rand() % (i+1);
		a[i] = a[randPos];
		a[randPos] = i;
	}

	for (int i = 0; i < N; i++) { 
		printf("%d\n", a[i]);
	}
}