



void* allocateMemory(int size) {
    void* temp = malloc(size);
    //printf("\nTrying to allocate %u\n", (unsigned int) size);
    if(temp == 0) {
        errorHandler(UNABLE_TO_ALLOCATE_MEM);
    }
    //printf("Allocated %u @ %u\n", (unsigned int) size, (unsigned int) temp);
    return temp;
}

void freeMemory(void* pointer) {
    //printf("\nTrying to free %u\n", (unsigned int) pointer);
    free(pointer);
    //printf("Freed %u\n", (unsigned int) pointer);
}




