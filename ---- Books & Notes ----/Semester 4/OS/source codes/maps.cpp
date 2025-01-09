#include<iostream>
using namespace std;
#include <stdio.h>
#include <semaphore.h>
#include <pthread.h>
#include <stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include <sys/mman.h>

char* map;

void* thread(void* x)
{
	for (int i = 0; i < 50; i++)
	{
		if ((((char*)x)[i]) >= '0' && (((char*)x)[i]) <= '9')
			(((char*)x)[i]) = ' ';
	}
	pthread_exit(0);
}
int main(int argc, char** argv)
{
	if (argc <= 1)
	{
		cout << "File not provided" << endl;
		return 0;
	}

	int fd = open(argv[1], O_RDWR, 0);
	if (fd < 1)
	{
		cout << "File not opened" << endl;
		return 0;
	}

	map = (char*)mmap(NULL, 100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	//void *mmap(void *addr NULL, size_t noOfBits, flags, shared/private, int fd, off_t offset)
	pthread_t tid[2];
	pthread_create(&tid[0], NULL, thread, (void*)map);
	pthread_create(&tid[1], NULL, thread, (void*)(map + 50));
	pthread_join(tid[0], NULL);
	pthread_join(tid[1], NULL);
	munmap(map, 100);
}
