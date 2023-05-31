#include <stdio.h>

int main() {
   int j=1;
   //one category for each book
   for(int i=1; i<151; i++){
       printf("(%d, %d),\n", j, i);
       j++;
       if(j==11) j=1;
   }
   //some books should belong to 2 categories
   j=2;
     for(int i=1; i<151; i+=13){
       printf("(%d, %d),\n", j, i);
       printf("(%d, %d),\n", j+1, i+1);
       j++;
       if(j==11) j=1;
   }
    return 0;
}
