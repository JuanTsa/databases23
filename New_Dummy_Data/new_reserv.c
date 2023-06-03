#include <stdio.h>

int main(){
        int user=10;
	int id=1;

	//10 copies of book_id = 14 reserved for user_id = 10-19
	for(int i=0; i<10; i++) printf("(%i, 14, %i, '2023-06-02', 'Approved'),\n", id++, user++);
   
	user=10;
	//10 copies of book_id = 29 reserved for user_id = 10-19
	for(int i=0; i<10; i++) printf("(%i, 29, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=20;
	//5 copies of book_id = 32 reserved for user_id = 20-24
	for(int i=0; i<5; i++) printf("(%i, 32, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=20;
	//5 copies of book_id = 35 reserved for user_id = 20-24
	for(int i=0; i<5; i++) printf("(%i, 35, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=351;
	//5 copies of book_id = 32 reserved for user_id = 351-356
	for(int i=0; i<5; i++) printf("(%i, 32, %i, '2023-06-02', 'Approved'),\n", id++, user++);

	user=351;
	//5 copies of book_id = 35 reserved for user_id = 351-356
	for(int i=0; i<5; i++) printf("(%i, 35, %i, '2023-06-02', 'Approved'),\n", id++, user++);
}	
