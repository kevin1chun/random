#pragma once

#define BIT_PIXEL 24
#define CHAR_PIXEL 3

#define MAX_LINE_SIZE 1024

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "errors.c"
#include "memory.c"
#include "Images/image.c"
#include "Images/imageOperations.c"




int fileExists(char* filename) {
    int temp;    
    FILE* file = fopen(filename, "r");
    if(file) {
        temp = 1;
        fclose(file);
    } else {
        temp = 0;
    }

    return temp;
}



char* getDouble(char** str) {
    char* temp = *str;
    while (**str != ' ' && **str != 0) {
        *str += 1;
    }
    **str = 0;
    *str += 1;
    return temp;
}

int countDoubles(char* str) {
    int i = 0;
    int count = 0;
    do {
        while(isspace(str[i]) && str[i] != 0) {
            i++;
        }
        if (isdigit(str[i])) {
            count++;
            while ( ((isdigit(str[i]) || str[i] == '.' ) && str[i] != 0)) {
                i++;
            }
        }
        i++;
    } while (str[i - 1] != 0);
    return count;
}

char* concat(char* str1, char* str2) {
    int len = strlen(str1) + strlen(str2) + 1;
    char* newString = allocateMemory(sizeof(char) * len);
    int i = 0;
    while (str1[i] != 0) {
        newString[i] = str1[i];
        i++;
    }
    int j = 0;
    while (str2[j] != 0) {
        newString[i] = str2[j];
        i++;
        j++;
    }
    newString[i] = 0;
    return newString;
}
/** Same as concat but frees the memory of str1 and str2. */
char* concatFree(char* str1, char* str2) {
    char* temp = concat(str1, str2);
    freeMemory(str1);
    freeMemory(str2);
    return temp;
}

/** Same as concat but frees the memory of str1. */
char* concatFreeFirst(char* str1, char* str2) {
    char* temp = concat(str1, str2);
    freeMemory(str1);
    return temp;
}

/** Same as concat but frees the memory of str1. */
char* concatFreeSecond(char* str1, char* str2) {
    char* temp = concat(str1, str2);
    freeMemory(str2);
    return temp;
}

char* removeNewLine(char** str) {
    int len = strlen(*str);
    if((*str)[len - 1] == '\n') {
        (*str)[len - 1] = 0;
    }
    return *str;
}

image* readFromDirectory(char* dir, char* filename) {
        char* full_filename = concat(dir, filename);
        image* temp = readBitMap(full_filename);
        freeMemory(full_filename);
        return temp;
}


