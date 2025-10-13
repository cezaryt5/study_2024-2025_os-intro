#include <stdio.h>
#include <stdlib.h>

int main() {
    double number;
    
    printf("Enter a number: ");
    scanf("%lf", &number);
    
    if (number > 0) {
        printf("The number is positive.\n");
        exit(1);  // Return 1 for positive number
    } else if (number < 0) {
        printf("The number is negative.\n");
        exit(2);  // Return 2 for negative number
    } else {
        printf("The number is zero.\n");
        exit(0);  // Return 0 for zero
    }
    
    return 0;
}