#include <cstdio>
#include <cstring>
#include <cstdlib>
#include "counters.h"
#include <sys/time.h>
#include <time.h>
#define FPOINT 2146435072


void opt_simd_sgemm(float *Y, float *A, float *B, int n);
void opt_scalar1_sgemm(float *Y, float *A, float *B, int n);
void opt_scalar0_sgemm(float *Y, float *A, float *B, int n);
void naive_sgemm(float *Y, float *A, float *B, int n);

int main(int argc, char *argv[])
{
	int n = (1<<10);
	float* A = new float[n*n];
	float* B = new float[n*n];
	float* Y = new float[n*n];


	uint64_t t1;
	uint64_t t2;

	hwCounter_t c;
	c.init = false;

	hwCounter_t cI;
	cI.init = false;

	initInsns(cI);

	initTicks(c);
	struct timeval tv1;
	struct timeval tv2;
	uint64_t count1;
	uint64_t count2;
	double time2;
	double time1;
	double delta;
	uint64_t cycles;
	double flops;
	double instrCycle;
	uint64_t executed;

	/// <----
	gettimeofday(&tv1, 0); //Begin
	t1 = getTicks(c);
	count1 = getInsns(cI);
	naive_sgemm(Y, A, B, n);
	count2 = getInsns(cI);
	t2 = getTicks(c);

	gettimeofday(&tv2, 0); //done

	executed = count2 - count1;

	cycles =  (t2 - t1);
	time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	delta = time2 - time1;

	flops = FPOINT / delta;
	instrCycle = (double)  executed / (double) cycles;

	printf("naive_sgemm: FLOPS = %f, INST = %lu, Cycle = %lu IPC = %f\n" , flops , executed, cycles, instrCycle);
	/// --->



	/// <----
	gettimeofday(&tv1, 0); //Begin
	count1 = getInsns(cI);
	t1 = getTicks(c);

	opt_simd_sgemm(Y, A, B, n);
	t2 = getTicks(c);

	count2 = getInsns(cI);

	gettimeofday(&tv2, 0); //done

	executed = count2 - count1;

	cycles = (t2 - t1);
	time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	delta = time2 - time1;

	flops = FPOINT / delta;
	instrCycle = (double)  executed / (double) cycles;

	printf("opt_simd_sgemm: FLOPS = %f, INST = %lu, Cycle = %lu IPC = %f\n" , flops , executed, cycles, instrCycle);
	/// --->




	/// <----
	gettimeofday(&tv1, 0); //Begin
	count1 = getInsns(cI);
	t1 = getTicks(c);

	opt_scalar1_sgemm(Y, A, B, n);
	t2 = getTicks(c);

	count2 = getInsns(cI);

	gettimeofday(&tv2, 0); //done

	executed = count2 - count1;

	cycles =  (t2 - t1);
	time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	delta = time2 - time1;

	flops = FPOINT / delta;
	instrCycle = (double)  executed / (double) cycles;

	printf("opt_scalar1_sgemm: FLOPS = %f, INST = %lu, Cycle = %lu IPC = %f\n" , flops , executed, cycles, instrCycle);
	/// --->



	/// <----
	gettimeofday(&tv1, 0); //Begin
	count1 = getInsns(cI);
	t1 = getTicks(c);

	opt_scalar0_sgemm(Y, A, B, n);
	t2 = getTicks(c);

	count2 = getInsns(cI);

	gettimeofday(&tv2, 0); //done

	executed = count2 - count1;

	cycles =  (t2 - t1);
	time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	delta = time2 - time1;

	flops = FPOINT / delta;
	instrCycle = (double)  executed / (double) cycles;

	printf("opt_scalar0_sgemm: FLOPS = %f, INST = %lu, Cycle = %lu IPC = %f\n" , flops , executed, cycles, instrCycle);
	/// --->




	delete [] A;
	delete [] B;
	delete [] Y;
	}
