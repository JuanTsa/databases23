#include <stdio.h>

int main() {
   int j=1;
   for(int i=1; i<151; i++){
       printf("(%d, %d),\n", j, i);
       j++;
       if(j==48) j=1;
   }
   
    return 0;
}
