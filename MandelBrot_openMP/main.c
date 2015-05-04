/* 
 * File:   main.c
 * Author: Marco
 *

 */

#define MAX_ITERS 1000000
#define MAX_TILL_DIVERGENT 100000000

#define cHeight 3
#define cWidth 3
#define cLeft -2
#define cTop -1.1

#include "core.c"
#include <math.h> 
#include <omp.h>
#include <sys/time.h>


typedef struct {
	double real;
	double imag;
} complex; 

int mandel(double a, double b) {
	int n;
	double zr = 0.0, zi = 0.0;
	double tzr, tzi;
	n = 0;
	while(n < MAX_ITERS && sqrt(zr*zr + zi*zi) < MAX_TILL_DIVERGENT) {
		tzr = (zr*zr - zi*zi) + a;
		tzi = (zr*zi + zr*zi) + b;
		zr = tzr;
		zi = tzi;
		n = n + 1;
	}
	if (n == MAX_ITERS)
		return 0;
	return n;
}

double get_real_at_pix(double x, double w) {

	double f = ((double) x) / w;
	return (f * cWidth) + cLeft;
}

double get_imag_at_pix(int x, int w) {
	double f = ((double) x) / w;
	return (f * cHeight) + cTop;
}

int main(int argc, char** argv) {
	srand (time(NULL));
    image* img = readBitMap("/home/marco/Desktop/MandelBrot/flopsVsThreads.bmp");
	padImage( img, 6400);
	padImageHeight( img, 4800);

	char file[256] = "/home/marco/Desktop/images/newXXX.bmp";

	
	int r = 3;
	int g = 9;
	int b = 3;
/*
	for(r = 0; r < 10; r ++) {
	for(g = 0; g < 10; g ++) {
	for(b = 0; b < 10; b ++) {
	file[30] = '0' + r ;
	file[31] = '0' + g;
	file[32] =  '0' + b;*/

    FILE* f = fopen (file , "w");
	struct timeval stop, start;
	gettimeofday(&start, NULL);


	int M;

    int i = 0;
	int j = 0;
	omp_set_num_threads(6);
	#pragma omp parallel  private(M, i, j)
	{
	printf ("Thread #%d reporting for duty\n", omp_get_thread_num());

	int start = (img->height / omp_get_num_threads())  * omp_get_thread_num();	
	int limit = start + (img->height / omp_get_num_threads()) ;	
	if (omp_get_thread_num() == omp_get_num_threads())
		limit = img->height;

	for(j = start; j < limit; j += 1) {
    		for(i = 0; i < img->width; i += 1) {

				int wOffset = i * img->bytesPerPixel;
				int hOffset = j * img->width * img->bytesPerPixel;
				double real = get_real_at_pix(i,img->width);
				double imag = get_imag_at_pix(j,img->width);
				M = mandel(real, imag);

		        img->pixels[hOffset + wOffset] = M *  g;
		        img->pixels[hOffset + wOffset + 1] = M * b;// M * 10;
		        img->pixels[hOffset + wOffset + 2] = M * r;

		        img->pixels[hOffset + wOffset] = img->pixels[hOffset + wOffset] % 255;
		        img->pixels[hOffset + wOffset + 1] = img->pixels[hOffset + wOffset + 1] % 255;
		        img->pixels[hOffset + wOffset + 2] = img->pixels[hOffset + wOffset + 2] % 255 ;
			
		}
    }
	}



    gettimeofday(&stop, NULL);

	printf("took %lu.%lus\n", (stop.tv_sec - start.tv_sec) , (stop.tv_usec -  + start.tv_usec) / 60);

    saveImage(img, f);


	//}}} 

	



    return (EXIT_SUCCESS);
}










