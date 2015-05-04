/*
 * This program displays the names of all files in the current directory.
 */
#include "../core.c"
#include <dirent.h> 


void cropImages(char* in_dir, char* out_dir, int input_widthL, int input_width, int input_heightB, int input_height) {
    char* makedir = "mkdir -p ";
    DIR           *d;
    struct dirent *dir;
    d = opendir(in_dir);
    if (d) {
        system(concat(makedir, out_dir));
        while ((dir = readdir(d)) != NULL) {
            char* inputFile = concat(in_dir, dir->d_name);
            if(isBitMap(inputFile)) {
                char* outputFile = concat(out_dir, dir->d_name);
                if (fileExists(outputFile)) {
                    image* imgOutput = readBitMapInfoOnly(outputFile);
                    if ((input_width - input_widthL) == imgOutput->width
                        && ((input_height - input_heightB) == imgOutput->height)) {
                        continue;
                    }
                    destroyImage(imgOutput);
                }

                image* img = readBitMap(inputFile);
                FILE* f = fopen (outputFile, "w");
                int width;

                if (img->width > input_width) {
                    width = input_width;
                } else {
                    width = img->width - 1;
                }
                padImageHeight(img, input_height);
                padImage(img, input_width);
                cropImage(img, input_widthL, input_width - 1, input_height - 1, input_heightB);

                saveImage(img, f);
                freeMemory(img);
                freeMemory(outputFile);
            }
            freeMemory(inputFile);
        }
        closedir(d);
    } else {
        printf("Unable to open directory %s \n", in_dir);
        exit(1);
    }
}


int main(int argc, char** argv)
{
    if(argc == 5) {
        int input_width = atoi(argv[3]);
        int input_height = atoi(argv[4]);
        cropImages(argv[1], argv[2], 0, input_width, 0, input_height);
    } else if(argc == 7) {
        int input_widthL = atoi(argv[3]);
        int input_heightB = atoi(argv[5]);
        int input_width = atoi(argv[4]);
        int input_height = atoi(argv[6]);
        cropImages(argv[1], argv[2], input_widthL, input_width, input_heightB, input_height);
    } else {
        printf("Usage: %s [input directory] [output directory] (widthL) [width] (heightB) [height]\n", argv[0]);
        return 1;
    }







    return (EXIT_SUCCESS);






}
