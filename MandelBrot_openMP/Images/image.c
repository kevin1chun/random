


typedef struct {
    char* filename;

    /** File Header Fields. */
    char* fileType;
    unsigned int fileSize;
    char* reserved;
    char* reserved2;
    unsigned int offset;

    /** DIB Header. */
    unsigned int DIBHeaderSize;
    unsigned int width;
    unsigned int height;
    unsigned int numColorPlanes;
    unsigned int bitsPerPixel;
    unsigned int compressionMethod;
    unsigned int imageSize;
    unsigned int horzResolution;
    unsigned int vertResolution;
    unsigned int colorsInPalette;
    unsigned int numImportantColors;

    unsigned int bytesPerPixel;
    /** Pixel array. */
    unsigned char* pixels;
} image;


int isBitMap(char* name) {
    int index = strlen(name) - 1;
    if (index < 3) {
        return 0;
    }
    return name[index - 3] == '.' && name[index - 2] == 'b' 
                && name[index - 1] == 'm' && name[index] == 'p'; 
}

/** Reads the DIB Header information from file into img. */
void readDIBHeader(image* img, FILE* file) {
    fseek(file, 0xE, SEEK_SET);
    img->DIBHeaderSize = readInt(file, 4);
    img->width = readInt(file, 4);
    img->height = readInt(file, 4);
    img->numColorPlanes = readInt(file, 2);
    img->bitsPerPixel = readInt(file, 2);
    
    img->bytesPerPixel = 3;

    img->compressionMethod = readInt(file, 4);
    img->imageSize = readInt(file, 4);
    img->horzResolution = readInt(file, 4);
    img->vertResolution = readInt(file, 4);
    img->colorsInPalette = readInt(file, 4);
    img->numImportantColors = readInt(file, 4);

}

/** Returns a n byte int value from file. */
int readInt(FILE* file, int n) {
    unsigned int temp = 0;
    unsigned int result = 0;
    //Warning Potenial endian problem.
    int i = 0;
    while(i < n) {
        temp = fgetc(file);
        temp = temp << (i * 8);
        result = temp | result;
        i++;
    }
    return result;
}

/** Write a 32 bit int to FILE. */
int writeInt(FILE* file, int n) {
    //Warning Potenial endian problem.
    fputc(n, file);
    fputc(n >> 8, file);
    fputc(n >> 16, file);
    fputc(n >> 24, file);
}

/** Reads the header information from file into img. */
void readFileHeader(image* img, FILE* file) {
    img->fileType = allocateMemory(sizeof(char) * 2);
    img->reserved = allocateMemory(sizeof(char) * 2);
    img->reserved2 = allocateMemory(sizeof(char) * 2);
    img->fileType = allocateMemory(sizeof(char) * 2);
    img->fileType[0] = fgetc(file);
    img->fileType[1] = fgetc(file);
    img->fileSize = readInt(file, 4);
    img->reserved[0] = fgetc(file);
    img->reserved[1] = fgetc(file);
    img->reserved2[0] = fgetc(file);
    img->reserved2[1] = fgetc(file);
    img->offset = readInt(file, 4);
}

/** Verifies the file header of img, must be called after readFilerHeader. */
void verifyFileHeader(image* img) {
    unsigned int invalid = 0;

    if(img->fileType[0] == 'B' && (img->fileType[1] == 'M' 
                                    || img->fileType[1] == 'A')) {
        invalid = invalid | 0x1;
    } else if (img->fileType[0] == 'C' && (img->fileType[1] == 'I' 
                                            || img->fileType[1] == 'P')) {
        invalid = invalid | 0x1;
    } else if (img->fileType[0] == 'I' && img->fileType[1] == 'C') {
        invalid = invalid | 0x1;
    } else if (img->fileType[0] == 'P' && img->fileType[1] == 'T') {
        invalid = invalid | 0x1;
    }

    if(img->fileSize > 0) {
        invalid = invalid | 0x2;
    }

    if(img->offset > 53) {
        invalid = invalid | 0x4;
    }
    if (invalid != 7) {
        errorWithString(INVALID_BMP_FILE, img->filename);
    }
}   

/** Verifies the DIB header of img, must be called after readDIBHeader. */
void verifyDIBHeader(image* img) {
    unsigned int invalid = 0;
invalid = invalid & 0x1;
    if(img->DIBHeaderSize > 0) {
        invalid = invalid | 0x1;
    }
    if(!(img->width > 0 && img->height > 0) ) {
        errorHandler(INVALID_IMAGE_DIMENSIONS);
    }
    if(img->numColorPlanes == 1) {
        invalid = invalid | 0x2;
    }
    if(img->numColorPlanes == 1) {
        invalid = invalid | 0x4;
    }
    if(img->bitsPerPixel != BIT_PIXEL) {
        errorHandler(INVALID_BITS_PIXEL);
    }
    if(img->compressionMethod != 0) {
        errorHandler(INVALID_COMPRESSION_TYPE);
    }
    if(img->imageSize > 0) {
        invalid = invalid | 0x8;
    }
    if (invalid != 15) {
        errorWithString(INVALID_BMP_FILE, img->filename);
    }
}   

/** Reads the pixel array of FILE into IMG, must be called
    after readFileHeader. */
void readPixelArray(image* img, FILE* file) {
    img->pixels = allocateMemory(getPixelArraySize(img) * sizeof(char));
    char c;
    fseek(file, img->offset, SEEK_SET);
    int paddingAmount = (4 - ((img->width * img->bytesPerPixel) % 4)) % 4;
    int i = 0;
    int j = 0;
    int bytesPerLine = (img->width * img->bytesPerPixel) + paddingAmount;
    int limit =  img->height * bytesPerLine;

    while(i < limit) {
        c = fgetc(file);
        if((i % bytesPerLine) < (img->width * img->bytesPerPixel)) {
            img->pixels[j] = c;
            j++;
        }
        i++;
    }
}

/** Reads the bitmap data from FILENAME and
 returns it as a image Struct, which MUST be freed.*/
image* readBitMap(char* filename) {
    image* img = (image*) allocateMemory(sizeof(image));
    img->filename = allocateMemory(sizeof(char) * strlen(filename) + 1);
    strcpy(img->filename, filename);

    FILE* file = fopen(filename, "r");
    if(!file) {
        errorWithString(FILE_DOESNT_EXIST, filename);
    }

    readFileHeader(img, file);
    verifyFileHeader(img);
    readDIBHeader(img, file);
    verifyDIBHeader(img);
    readPixelArray(img, file);
    return img;
}

image* readBitMapInfoOnly(char* filename) {
    image* img = (image*) allocateMemory(sizeof(image));
    img->filename = allocateMemory(sizeof(char) * strlen(filename) + 1);
    strcpy(img->filename, filename);

    FILE* file = fopen(filename, "r");
    if(!file) {
        errorWithString(FILE_DOESNT_EXIST, filename);
    }

    readFileHeader(img, file);
    verifyFileHeader(img);
    readDIBHeader(img, file);
    verifyDIBHeader(img);
    img->pixels = 0;
    return img;
}


/** Returns an image with the same header information as IMG, 
    but without a pixel array. */
image* copyImgInfo(image* img) {
    image* copy = allocateMemory(sizeof(image));

    copy->fileType = img->fileType;
    copy->fileSize = img->fileSize;
    copy->reserved = img->reserved;
    copy->reserved2 = img->reserved2;
    copy->offset = img->offset;

    copy->DIBHeaderSize = img->DIBHeaderSize;
    copy->width = img->width;
    copy->height = img->height;
    copy->numColorPlanes = img->numColorPlanes;
    copy->bitsPerPixel = img->bitsPerPixel;
    copy->compressionMethod = img->compressionMethod;
    copy->imageSize = img->imageSize;
    copy->horzResolution = img->horzResolution;
    copy->vertResolution = img->vertResolution;
    copy->colorsInPalette = img->colorsInPalette;
    copy->numImportantColors = img->numImportantColors;

    copy->bytesPerPixel = img->bytesPerPixel;
    return copy;
}


/** Prints the header of img.*/
void printImage(image* img) {
    printf("Bitmap Type: %c%c\n", img->fileType[0], img->fileType[1]);
    printf("File Size: %d\n", img->fileSize);
    printf("Reserved 1: %c%c\n", img->reserved[0], img->reserved[1]);
    printf("Reserved 2: %c%c\n", img->reserved2[0], img->reserved2[1]);
    printf("Bitmap Offset: %d\n", img->offset);
    printf("DIB Header Size: %d\n", img->DIBHeaderSize);
    printf("Width: %d\n", img->width);
    printf("Height: %d\n", img->height);
    printf("Number of Color Planes: %d\n", img->numColorPlanes);
    printf("Bits Per Pixel: %d\n", img->bitsPerPixel);
    printf("Compression Method: %d\n", img->compressionMethod);
    printf("Image Size: %d\n", img->imageSize);
    printf("Horizontal Resolution: %d\n", img->horzResolution);
    printf("Vertical Resolution: %d\n", img->vertResolution);
    printf("Colors In Palette: %d\n", img->colorsInPalette);
    printf("Number of Important Colors: %d\n", img->numImportantColors);

    printf("Pixel Array \n");

    int i = 0;
    int limit = getPixelArraySize(img);
    while(i < limit) {
        putc(img->pixels[i], stdout);
        i++;
    }
    printf("\n");
}

int getPixelArraySize(image* img) {
    return img->width * img->height * img->bytesPerPixel;
}

int printChar(unsigned char b) {
    printf("%f ", (double) b / (double) 255.00);
}

double* pixelArrayDouble(image* img, int reduction) {
    double* pixels = allocateMemory(sizeof(double) * (getPixelArraySize(img) / reduction));
    int i = 0;
    int j = 0;
    int limit = getPixelArraySize(img) / reduction;
    while (i < limit) {
        pixels[j] = (double) img->pixels[i] / (double) 255.00;
        pixels[j + 1] = (double) img->pixels[i + 1] / (double) 255.00;
        pixels[j + 2] = (double) img->pixels[i + 2] / (double) 255.00;
        i += img->bytesPerPixel * reduction;
        j += 3;
    }
    return pixels;
}

void printPixelArray(image* img, int reduction) {
    double* Pixels = pixelArrayDouble(img, reduction);
    int i = 0;
    int limit = getPixelArraySize(img);
    while (i < limit / reduction) {
        printf("%f ", Pixels[i]);
        i++;
    }
    freeMemory(Pixels);
}


/** Saves IMG to file F. */
void saveImage(image* img, FILE* f) {
    fprintf(f, "%c%c", img->fileType[0], img->fileType[1]);
    writeInt(f, img->fileSize);
    fputc(img->reserved[0], f);
    fputc(img->reserved[1], f);
    fputc(img->reserved2[0], f);
    fputc(img->reserved2[1], f);
    writeInt(f, img->offset);
    writeInt(f, img->DIBHeaderSize);
    writeInt(f, img->width);
    writeInt(f, img->height);
    fputc(img->numColorPlanes, f);
    fputc(img->numColorPlanes >> 8, f);
    fputc(img->bitsPerPixel, f);
    fputc(img->bitsPerPixel >> 8, f);
    writeInt(f, img->compressionMethod);
    writeInt(f, img->imageSize);
    writeInt(f, img->horzResolution);
    writeInt(f, img->vertResolution);
    writeInt(f, img->colorsInPalette);
    writeInt(f, img->numImportantColors);
    int padding = (4 - ((img->width * img->bytesPerPixel) % 4)) % 4;
    int stop = padding * img->height + img->width * img->height * img->bytesPerPixel;
    int h = 0;
    int j = 0;
    int i = 0;
    for(h = 0; h < img->height; h++) {
        int w;
        for(w = 0; w < img->width * img->bytesPerPixel; w++) {
            fputc(img->pixels[h * img->width * img->bytesPerPixel + w] , f);
        }
        int i;
        for(i = 0; i < padding; i++) {
            fputc(0, f);
        }
    }
}

void saveImageToFile(image* img, char* filename) {
    FILE* f = fopen (filename, "w");
    saveImage(img, f);
    fclose(f);
}

 
 /** Frees all memory associated with img. */
void destroyImage(image* img) {
    freeMemory(img->fileType);
    freeMemory(img->filename);
    if (img->pixels !=  0) {
        freeMemory(img->pixels);
    }
    freeMemory(img);
}




