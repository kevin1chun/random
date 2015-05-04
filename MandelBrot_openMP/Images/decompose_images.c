/*
 * This program displays the names of all files in the current directory.
 */
#include "../core.c"
#include <dirent.h> 



int decompose(char* filename) {
    image* img = readBitMap(filename);
    int size = getPixelArraySize(img);
    int blue = 0;
    int green = 0;
    int red = 0;

    int i = 0;
    while( i < size) {
        blue += img->pixels[i];
        green += img->pixels[i + 1];
        red += img->pixels[i + 2];
        i += 3;
    }
    printf("%d, %d, %d\n", blue / (size / 3), green / (size / 3), red / (size / 3));
    
}

int main(int argc, char** argv)
{
    if(argc != 2) {
        printf("Usage: %s [input directory]\n", argv[0]);
        return 1;
    }



    decompose(argv[1]);





    return (EXIT_SUCCESS);






}
