

/** Crops img
    Pixels are indexed from left to right (0 to width - 1),
    and from bottom to top (0 to height - 1).
 */

image* cropImage(image* img, unsigned int widthL, unsigned int widthR, unsigned int heightU, unsigned int heightL) {
    if (widthL < 0 || widthR < 0) {
        printf("%s\n", img->filename);
        errorWithString(IMAGE_OP_ERROR, "Negative width specified in cropImage.\n");
    }
    if (widthR >= img->width) {
        printf("%s\n", img->filename);
        errorWithString(IMAGE_OP_ERROR, "The right width parameter exceeds the width of the image in cropImage.\n");
    }
    if (widthL > widthR) {
        printf("%s\n", img->filename);
        errorWithString(IMAGE_OP_ERROR, "The left width parameter is greater than, or equal too, the right width parameter, in cropImage.\n");
    }
    if (heightU < 0 || heightL < 0) {
        printf("%s\n", img->filename);
        errorWithString(IMAGE_OP_ERROR, "Negative height specified in cropImage.\n");
    }
    if (heightU >= img->height) {
        printf("%s\n", img->filename);
        errorWithString(IMAGE_OP_ERROR, "The upper height parameter exceeds the height of the image in cropImage.\n");
    }
    if (heightL > heightU) {
        printf("%s\n", img->filename);
        errorWithString(IMAGE_OP_ERROR, "The lower height parameter is greater than, or equal too, the upper height parameter, in cropImage.\n");
    }

    int h = heightL * img->width * img->bytesPerPixel;
    int hStop = (heightU + 1) * img->width * img->bytesPerPixel;
    int wStart = widthL * img->bytesPerPixel;
    int wStop = (widthR + 1) * img->bytesPerPixel;
    int increment = img->width * img->bytesPerPixel;
    int pixelArraySize = (heightU - heightL + 1) * (widthR - widthL + 1) * img->bytesPerPixel;
    img->fileSize = img->fileSize - getPixelArraySize(img) + pixelArraySize;
    char* pixels = allocateMemory(pixelArraySize * sizeof(char));
    img->height = heightU - heightL + 1;
    img->width = widthR - widthL + 1;
    int i = 0;
    for(h = h; h < hStop; h+= increment) {
        int r = 0;
        for(r = wStart; r < wStop; r++) {
            pixels[i] = img->pixels[h + r];
            i++;
        }
    }
    freeMemory(img->pixels);
    img->pixels = pixels;
    return img;
}


/** Returns a grey scale image. */
image* greyScale(image* img) {

    char* grey = allocateMemory(getPixelArraySize(img) * sizeof(char));
    

    int i = 0;

    for(i = 0; i < getPixelArraySize(img); i+= img->bytesPerPixel) {
        int avg = averagePixel(img, i);
        grey[i] = avg;
        grey[i + 1] = avg;
        grey[i + 2] = avg;
    }
    freeMemory(img->pixels);
    img->pixels = grey;
    return img;
}

int averagePixel(image* img, int pixel) {
    return (img->pixels[pixel] 
    + img->pixels[pixel + 1] 
    + img->pixels[pixel + 2]) / img->bytesPerPixel;
}

/** Adjusts the contrast of an image. */
image* adjustContrast(image* img, int inc, int tolerance) {
    image* adjusted = copyImgInfo(img);
    adjusted->pixels = allocateMemory(getPixelArraySize(adjusted) * sizeof(char));
    int i = 0;
    for(i = 0; i < getPixelArraySize(adjusted); i+= img->bytesPerPixel) {
        int avg = averagePixel(img, i);
        if (avg > tolerance) {
            adjusted->pixels[i] += inc;
            adjusted->pixels[i + 1] += inc;
            adjusted->pixels[i + 2] += inc;
        } else {
            adjusted->pixels[i] -= inc;
            adjusted->pixels[i + 1] -= inc;
            adjusted->pixels[i + 2] -= inc;
        }
    }
    return adjusted;
}

/** Pads the image IMG to WIDTH by adding black pixels on the right. */

image* padImage(image* img, int width) {
    if (width > img->width) {
        int pixelArraySize = img->height * width * img->bytesPerPixel;
        char* pixels = allocateMemory(pixelArraySize * sizeof(char));
        int row;
        int i = 0;
        int bytesRow = img->width * img->bytesPerPixel;
        int widthAddition = (width - img->width) * img->bytesPerPixel;
        for(row = 0; row < img->height; row++) {
            int element;
            for(element = 0; element < bytesRow; element++) {
                pixels[i] = img->pixels[row * bytesRow + element];
                i++;
            }
            int j;
            for(j = 0; j < widthAddition; j++) {
                pixels[i] = 0;
                i++;
            }
        }
        freeMemory(img->pixels);
        img->pixels = pixels;
        img->width = width;
    }
    return img;
}

/** Pads the image IMG to HEIGHT by adding black pixels on the bottom. */

image* padImageHeight(image* img, int height) {
    if (height > img->height) {
        int pixelArraySize = img->width * height * img->bytesPerPixel;
        int additionalChar = pixelArraySize - getPixelArraySize(img);
        char* pixels = allocateMemory(pixelArraySize * sizeof(char));
        int i = 0;


        while (i < additionalChar) {
            pixels[i] = 0;
            i++;
        }

        int j = 0;
        while (j < getPixelArraySize(img)) {
            pixels[i] = img->pixels[j];           
            i++;
            j++;
        }


        freeMemory(img->pixels);
        img->pixels = pixels;
        img->height = height;
    }
    return img;
}

/** scales IMG by 1/FACTOR. */
image* scaleImage(image* img, int factor) {
    unsigned char* pixels = allocateMemory(img->width * img->height * img->bytesPerPixel );
    int i = 0;
    int j = 0;
    int arraySize = getPixelArraySize(img);
    while (i < arraySize) {
        int temp = i % (img->width * img->bytesPerPixel * factor);
        if (temp == 0) {
            i += img->width * img->bytesPerPixel;
            continue;
        }
        if ((i % (img->width * 3)) % factor) {
            pixels[j] = img->pixels[i];
            pixels[j + 1] = img->pixels[i + 1];
            pixels[j + 2] = img->pixels[i + 2];
            j += 3;
        }
        i += 3;
    }
    img->height = img->height * (((double) factor - 1.00) / (double) factor);
    img->width = img->width * (((double) factor - 1.00) / (double) factor);
    freeMemory(img->pixels);
    img->pixels = pixels;    
    return img;
}

int samplePixelChar(image* img, int i) {
    unsigned int total = 0;
    int count = 0;
    int firstLine = img->width * img->bytesPerPixel;
    int lineSize = img->width;
    int lastLine = getPixelArraySize(img) - firstLine;
    
    if (i > firstLine) {
        if (i % firstLine != 0) { 
            total += img->pixels[i - firstLine - 3];
            count++;
        }
        total += img->pixels[i - firstLine];
        count++;
        if (i % firstLine != (firstLine - 1)) { 
            total += img->pixels[i - firstLine + 3];
            count++;
        }
    }
    if (i % firstLine != 0) {
        total += img->pixels[i - 3];
        count++;
    }
    total += img->pixels[i];
    count++;
    if (i % firstLine != (firstLine - 1)) { 
        total += img->pixels[i + 3];
        count++;
    }
    if (i < lastLine) {
        if (i % firstLine != 0) {
            total += img->pixels[i + firstLine - 3];
            count++;
        }
        total += img->pixels[i + firstLine];
        count++;
        if (i % firstLine != (firstLine - 1)) { 
            total += img->pixels[i + firstLine + 3];
            count++;
        }
    }
    return total / count;
}




















