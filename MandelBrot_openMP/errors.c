
#define UNABLE_TO_ALLOCATE_MEM 0

#define INVALID_BMP_FILE 1

#define INVALID_IMAGE_DIMENSIONS 2

#define INVALID_BITS_PIXEL 3

#define INVALID_COMPRESSION_TYPE 4

#define DB_ERROR 5

#define IMAGE_OP_ERROR 6

#define INCONSISTENT_NUM_OUTPUT 7 

#define FILE_DOESNT_EXIST 8 

#define INVALID_TRAINING_FILE 9

#define CARD_COLOR_LOW_CONFG 10

void superficialError(int error) {
    if (error == UNABLE_TO_ALLOCATE_MEM) {
        printf("Unable to Allocate Memory.");
    } else if (error == INVALID_BMP_FILE) {
        printf("Invalid or Unsupported File.");
    } else if (error == INVALID_IMAGE_DIMENSIONS) {
        printf("Image with invalid dimensions.");
    } else if (error == INVALID_BITS_PIXEL) {
        printf("Bitmaps are required to have %d bits per pixel.", BIT_PIXEL);
    } else if (error == INVALID_COMPRESSION_TYPE) {
        printf("Compressed bitmap files are not supported.");
    } else if (error ==INCONSISTENT_NUM_OUTPUT) {
        printf("Inconsistent number of outputs.");
    } else if (error == FILE_DOESNT_EXIST) {
        printf("File does not exist.");
    } else if(error == INVALID_TRAINING_FILE) {
        printf("This training header file seems to be invalid.");
    } else if(error == CARD_COLOR_LOW_CONFG) {
        printf("Card color confidence is low.");
    }
    printf("\n");
}


void errorHandler(int error) {
    superficialError(error);
    exit(1);
}

void errorWithString(int error, const char* errorString) {
    printf("\n%s : ", errorString);
    errorHandler(error);
}

void superficialErrorWithString(int error, const char* errorString) {
    printf("\n%s : ", errorString);
    superficialError(error);
}










