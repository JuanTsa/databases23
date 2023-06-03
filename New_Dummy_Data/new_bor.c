#include <stdio.h>

int main(){
  int user=25;
	int id=1;

	//10 copies of book_id = 14 borrowed for user_id = 25-34
	for(int i=0; i<10; i++) printf("(%i, 14, %i, '2023-06-02', 'Approved'),\n", id++, user++);
   
	user=25;
	//10 copies of book_id = 29 borrowed for user_id = 25-34
	for(int i=0; i<10; i++) printf("(%i, 29, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=35;
	//5 copies of book_id = 32 borrowed for user_id = 35-39
	for(int i=0; i<5; i++) printf("(%i, 32, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=35;
	//5 copies of book_id = 35 borrowed for user_id = 35-39
	for(int i=0; i<5; i++) printf("(%i, 35, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=361;
	//5 copies of book_id = 32 borrowed for user_id = 351-356
	for(int i=0; i<5; i++) printf("(%i, 32, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=351;
	//5 copies of book_id = 35 borrowed for user_id = 351-356
	for(int i=0; i<5; i++) printf("(%i, 35, %i, '2023-06-02', 'Approved'),\n", id++, user++);
}	
