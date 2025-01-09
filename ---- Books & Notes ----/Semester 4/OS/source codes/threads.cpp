#include <iostream>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
using namespace std;

int x = 0;
sem_t S;

void* ProcessWX(void* arg)
{
    for (int i = 0; i < 3; i++)
    {
        sem_wait(&S);
        x = x + 1;
        cout << "Increment: x+1= " << x << endl;
        sem_post(&S);
    }
    pthread_exit(0);
}

void* ProcessYZ(void* arg)
{
    for (int i = 0; i < 3; i++)
    {
        sem_wait(&S);
        x = x - 2;
        cout << "Decrement: x-2= " << x << endl;
        sem_post(&S);
    }
    pthread_exit(0);
}

int main()
{
    sem_init(&S, 0, 1);
    pthread_t t1, t2, t3, t4;
    pthread_create(&t1, NULL, ProcessWX, NULL);
    pthread_create(&t2, NULL, ProcessWX, NULL);
    pthread_create(&t3, NULL, ProcessYZ, NULL);
    pthread_create(&t4, NULL, ProcessYZ, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);
    pthread_join(t4, NULL);
    sem_destroy(&S);
    cout << "Final value of X (after 3 iterations of each process): " << x << endl;
}
