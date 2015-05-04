#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <unistd.h>
#include <sys/time.h>
#include <time.h>
#include <emmintrin.h>
#include <omp.h>

using namespace std;

double timestamp()
{
  struct timeval tv;
  gettimeofday (&tv, 0);
  return tv.tv_sec + 1e-6*tv.tv_usec;
}

// Simple Blur
void simple_blur(float* out, int n, float* frame, int* radii){
  for(int r=0; r<n; r++)
    for(int c=0; c<n; c++){
      int rd = radii[r*n+c];
      int num = 0;
      float avg = 0;
      for(int r2=max(0,r-rd); r2<=min(n-1, r+rd); r2++)
        for(int c2=max(0, c-rd); c2<=min(n-1, c+rd); c2++){
          avg += frame[r2*n+c2];
          num++;
        }
      out[r*n+c] = avg/num;
    }
}

// My Blur
void my_blur(float* out, int n, float* frame, int* radii){
	omp_set_num_threads(16);

	
	#pragma omp parallel for schedule(dynamic, 1) 
	for(int r=0; r<n; r+= 1) {
		__m128 tinse;	
		int num ;
		float avg;
		float temp[4];
		__m128 tAvg;
		int r2Max;
		int c2Max;
		int r2Min;
		int c2Min;
	
		for(int c=0; c<n; c+=1){
			int rd = radii[r*n+c];
			num = 0;
			avg = 0;
			tAvg = _mm_setzero_ps ();
			r2Max = min(n-1, r+rd);
			c2Max = min(n-1, c+rd);
			r2Min = max(0,r-rd);
			c2Min =max(0, c-rd);
			for(int r2= r2Min; r2<= r2Max; r2++) {
				for(int c2 =c2Min; c2 + 4 <= c2Max;){
					tinse =  _mm_loadu_ps(frame + r2*n+c2);
					tAvg = _mm_add_ps (tinse, tAvg);
					num+=4;	
					c2+=4;
				}
				for(int c2 = c2Min + ((c2Max - c2Min) / 4) * 4; c2 <= c2Max; c2++){
					avg += frame[r2*n+c2];
					num++;
				}
			}
			
			_mm_storeu_ps (temp, tAvg);
			for (int i = 0; i < 4; i++) {
				avg += temp[i];
			}
			
			out[r*n+c] = avg/num;
			
		}
	}

}

int main(int argc, char *argv[])
{
  //Generate random radii
  srand(0);
  int n = 3000;
  int* radii = new int[n*n];
  for(int i=0; i<n*n; i++)
    radii[i] = 6*i/(n*n) + rand()%6;

  //Generate random frame
  float* frame = new float[n*n];
  for(int i=0; i<n*n; i++)
    frame[i] = rand()%256;

  //Blur using simple blur
  float* out = new float[n*n];
  double time = timestamp();
  simple_blur(out, n, frame, radii);
  time = timestamp() - time;

  //Blur using your blur
  float* out2 = new float[n*n];
  double time2 = timestamp();
  my_blur(out2, n, frame, radii);
  time2 = timestamp() - time2;

  //Check result
  for(int i=0; i<n; i++)
    for(int j=0; j<n; j++){
      float dif = out[i*n+j] - out2[i*n+j];
      if(dif*dif>1.0f){
        printf("Your blur does not give the right result!\n");
        printf("For element (row, column) = (%d, %d):\n", i, j);
        printf("  Simple blur gives %.2f\n", out[i*n+j]);
        printf("  Your blur gives %.2f\n", out2[i*n+j]);
        exit(-1);
      }
  }

  //Delete
  delete[] radii;
  delete[] frame;
  delete[] out;
  delete[] out2;

  //Print out Time
  printf("Time needed for naive blur = %.3f seconds.\n", time);
  printf("Time needed for your blur = %.3f seconds.\n", time2);
}

