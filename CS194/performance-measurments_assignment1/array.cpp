#include <emmintrin.h>
#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <cstring>
#include <sys/time.h>
#include <time.h>

void simd_memcpy(void *dst, void *src, size_t nbytes)
{
  size_t i;

  size_t ilen = nbytes/sizeof(int);
  size_t ilen_sm = ilen - ilen%16;

  char *cdst=(char*)dst;
  char *csrc=(char*)src;

  int * idst=(int*)dst;
  int * isrc=(int*)src;

  __m128i l0,l1,l2,l3;

  _mm_prefetch((__m128i*)&isrc[0], _MM_HINT_NTA);
  _mm_prefetch((__m128i*)&isrc[4], _MM_HINT_NTA);
  _mm_prefetch((__m128i*)&isrc[8], _MM_HINT_NTA);
  _mm_prefetch((__m128i*)&isrc[12], _MM_HINT_NTA);
  
  for(i=0;i<ilen_sm;i+=16)
    {
      l0 =  _mm_load_si128((__m128i*)&isrc[i+0]);
      l1 =  _mm_load_si128((__m128i*)&isrc[i+4]);
      l2 =  _mm_load_si128((__m128i*)&isrc[i+8]);
      l3 =  _mm_load_si128((__m128i*)&isrc[i+12]);
    
      _mm_prefetch((__m128i*)&isrc[i+16], _MM_HINT_NTA);
      _mm_prefetch((__m128i*)&isrc[i+20], _MM_HINT_NTA);
      _mm_prefetch((__m128i*)&isrc[i+24], _MM_HINT_NTA);
      _mm_prefetch((__m128i*)&isrc[i+28], _MM_HINT_NTA);

      _mm_stream_si128((__m128i*)&idst[i+0],  l0);
      _mm_stream_si128((__m128i*)&idst[i+4],  l1);
      _mm_stream_si128((__m128i*)&idst[i+8],  l2);
      _mm_stream_si128((__m128i*)&idst[i+12], l3);

    }

  for(i=ilen_sm;i<ilen;i++)
    {
      idst[i] = isrc[i];
    }

  for(i=(4*ilen);i<nbytes;i++)
    {
      cdst[i] = csrc[i];
    }
}

void simd_memcpy_cache(void *dst, void *src, size_t nbytes)
{
  size_t i;
  size_t sm = nbytes - nbytes%sizeof(int);
  size_t ilen = nbytes/sizeof(int);
  size_t ilen_sm = ilen - ilen%16;

  //printf("nbytes=%zu,ilen=%zu,ilen_sm=%zu\n",
  //nbytes,ilen,ilen_sm);


  char *cdst=(char*)dst;
  char *csrc=(char*)src;

  int * idst=(int*)dst;
  int * isrc=(int*)src;

  __m128i l0,l1,l2,l3;

  _mm_prefetch((__m128i*)&isrc[0], _MM_HINT_T0);
  _mm_prefetch((__m128i*)&isrc[4], _MM_HINT_T0);
  _mm_prefetch((__m128i*)&isrc[8], _MM_HINT_T0);
  _mm_prefetch((__m128i*)&isrc[12], _MM_HINT_T0);
  
  for(i=0;i<ilen_sm;i+=16)
    {
      l0 =  _mm_load_si128((__m128i*)&isrc[i+0]);
      l1 =  _mm_load_si128((__m128i*)&isrc[i+4]);
      l2 =  _mm_load_si128((__m128i*)&isrc[i+8]);
      l3 =  _mm_load_si128((__m128i*)&isrc[i+12]);
    
      _mm_prefetch((__m128i*)&isrc[i+16], _MM_HINT_T0);
      _mm_prefetch((__m128i*)&isrc[i+20], _MM_HINT_T0);
      _mm_prefetch((__m128i*)&isrc[i+24], _MM_HINT_T0);
      _mm_prefetch((__m128i*)&isrc[i+28], _MM_HINT_T0);

      _mm_store_si128((__m128i*)&idst[i+0],  l0);
      _mm_store_si128((__m128i*)&idst[i+4],  l1);
      _mm_store_si128((__m128i*)&idst[i+8],  l2);
      _mm_store_si128((__m128i*)&idst[i+12], l3);

    }

  for(i=ilen_sm;i<ilen;i++)
    {
      idst[i] = isrc[i];
    }

  for(i=(ilen*4);i<nbytes;i++)
    {
      cdst[i] = csrc[i];
    }
}

void copy_array(int *dst, int *src, int ilen) {

	for(long long i = 0; i < ilen; i++) {
		dst[i] = src[i];
	}

}

int main (int argc, char *argv[]) { // START STOP STEP TRIALS
	printf("bytes, naive, simd, simd cache\n" );

	int START = atoi(argv[1]);
	int STOP = atoi(argv[2]);
	int STEP = atoi(argv[3]);
	int numTests = atoi(argv[4]) ;

	for (int bytes = START; bytes < STOP; bytes += STEP) {
	struct timeval tv1;
	struct timeval tv2;

	int N = bytes / sizeof(int) ; //number Ints


	int integerNumTotalBytes = numTests * bytes;
	double totalByes = (double) numTests * bytes;
	double totalBits = totalByes * 8;

	printf("%d, " , bytes);


	int *myarray = new int[N];
	int *copiedArray = new int[N];

	int *simd1 = new int[N];
	int *simd2 = new int[N];


	for(long long i=0; i<N; i++) {
		myarray[i] = i;
	}

//////////////////////
	for (int i = 0; i < numTests; i++) { //warmup
		copy_array(copiedArray, myarray, N ); 
	}

	gettimeofday(&tv1, 0); //Begin
	for (int i = 0; i < numTests; i++) { //run tests
		copy_array(copiedArray, myarray, N ); 
	}
	gettimeofday(&tv2, 0); //done

	double time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	double time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	double delta = time2 - time1;

	double avgBandwith = (totalBits)  / (delta * 1000000); 

	printf("%f, ",  avgBandwith);
	////////////////



////////////
	for (int i = 0; i < numTests; i++) { //warmup
		simd_memcpy (copiedArray, myarray, bytes ); 
	}

	gettimeofday(&tv1, 0); //Begin
	for (int i = 0; i < numTests; i++) { //run tests
		simd_memcpy (copiedArray, myarray, bytes ); 
	}
	gettimeofday(&tv2, 0); //done

	 time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	 time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	 delta = time2 - time1;

	 avgBandwith = (totalBits)  / (delta * 1000000); 

	printf("%f, ",  avgBandwith);
//////////////

////////////
	for (int i = 0; i < numTests; i++) { //warmup
		simd_memcpy_cache (copiedArray, myarray, bytes ); 
	}

	gettimeofday(&tv1, 0); //Begin
	for (int i = 0; i < numTests; i++) { //run tests
		simd_memcpy_cache (copiedArray, myarray, bytes ); 
	}
	gettimeofday(&tv2, 0); //done

	 time1 = tv1.tv_sec + 1e-6 * tv1.tv_usec;
	 time2 = tv2.tv_sec + 1e-6 * tv2.tv_usec;
	 delta = time2 - time1;

	 avgBandwith = (totalBits)  / (delta * 1000000); 

	printf("%f\n",  avgBandwith);

	}
	///////////////
}
