#include <stdio.h>

int main() {
   int j=1;
   //one author for each book
   for(int i=1; i<151; i++){
       printf("(%d, %d),\n", j, i);
       j++;
       if(j==47) j=1;
   }
   //some books should have two authors
   j=2;
   for(int i=1; i<151; i+=13){
       printf("(%d, %d),\n", j, i);
       printf("(%d, %d),\n", j+1, i+1);
       j++;
       if(j==47) j=1;
   }
   
    return 0;
}
