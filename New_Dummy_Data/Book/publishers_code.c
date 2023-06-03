#include <stdio.h>
#include <string.h>
#define MAX_TITLE_LENGTH 100

int main() {
    FILE *inputFile = fopen("publishers_names.txt", "r");
    if (inputFile == NULL) {
        printf("Failed to open the input file.\n");
        return 1;
    }

    FILE *outputFile = fopen("final_publishers.txt", "w");
    if (outputFile == NULL) {
        printf("Failed to open the output file.\n");
        fclose(inputFile);
        return 1;
    }

    char title[MAX_TITLE_LENGTH];
    int isFirstTitle = 1;

    while (fgets(title, MAX_TITLE_LENGTH, inputFile) != NULL) {
        int len = strlen(title);
        if (len > 0 && title[len - 1] == '\n') {
            title[len - 1] = '\0';
        }


        if (!isFirstTitle) {
            fprintf(outputFile, ", ");
        }
        fprintf(outputFile, "%s", title);

        isFirstTitle = 0;
    }


    fclose(inputFile);
    fclose(outputFile);

    printf("Output written to 'final_publishers.txt' file.\n");

    return 0;
}
