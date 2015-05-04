/*
 * This program displays the names of all files in the current directory.
 */
#include "../core.c"
#include <dirent.h> 



int scaleImages(char* in_dir, char* out_dir, char* input_width) {

    char* makedir = "mkdir -p ";
    char* convertGeometry = "convert -geometry '";
    char* sysCmd;

    DIR* d;
    struct dirent *dir;
    d = opendir(in_dir);
    if (d) {
        sysCmd = concat(makedir, out_dir);
        system(sysCmd);
        freeMemory(sysCmd);
        while ((dir = readdir(d)) != NULL) {
            char* inputFile = concat(in_dir, dir->d_name);

            if(isBitMap(inputFile)) {
                char* outputFile = concat(out_dir, dir->d_name);

                if (fileExists(outputFile)) {
                    image* img = readBitMapInfoOnly(outputFile);

                    if (atoi(input_width) == img->width) {
                        continue;
                    }
                    destroyImage(img);
                }


                sysCmd = concat(convertGeometry, input_width);
                sysCmd = concatFreeFirst(sysCmd, "' '");
                sysCmd = concatFree(sysCmd, inputFile);
                sysCmd = concatFreeFirst(sysCmd, "' '");
                sysCmd = concatFree(sysCmd, outputFile);
                sysCmd = concatFreeFirst(sysCmd, "'");
                system(sysCmd);
            }
        }
        closedir(d);
    } else {
        printf("Unable to open directory %s \n", in_dir);
        exit(1);
    }

}


int main(int argc, char** argv)
{
    if(argc != 4) {
        printf("Usage: %s [input directory] [output directory] [width]\n", argv[0]);
        return 1;
    }



    scaleImages(argv[1], argv[2], argv[3]);





    return (EXIT_SUCCESS);






}
