/*
 * This program displays the names of all files in the current directory.
 */
#include "../core.c"
#include <dirent.h> 


void cropImages(char* in_dir, char* out_dir, int reduction, int applications) {
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
                image* img = readBitMap(inputFile);
                FILE* f = fopen (outputFile, "w");
                int temp = applications;
                while (temp > 0) {
                    scaleImage(img, reduction);
                    temp--;
                }
                saveImage(img, f);
                destroyImage(img);
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
    if(argc != 5) {
        printf("Usage: %s [input directory] [output directory] [reduction (1/r)] [# times to apply r]\n", argv[0]);
        return 1;
    }

    cropImages(argv[1], argv[2], atoi(argv[3]), 1);

    return (EXIT_SUCCESS);
}
