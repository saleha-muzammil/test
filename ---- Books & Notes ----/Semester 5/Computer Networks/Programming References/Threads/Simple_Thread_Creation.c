/*
        This program will create two independent threads within a main thread and print their IDs w.r.t their creation order using
        a thread function called using pthread_create function available in pthread.h library
*/

#include <stdio.h>
#include <pthread.h>

int tid=1;

void *print_thread_id (void *arg)
{
        printf("This is Thread %d\n",tid);
        tid++;
        pthread_exit(NULL);       
}

int main(void)
{
        pthread_t thread1,thread2;
        
        int ret1 = pthread_create(&thread1, NULL, print_thread_id, NULL);
        if (ret1!=0)
        {
                printf("Error In Creating Thread with ID:%d\n",tid1);
        }
        
        int ret2 = pthread_create(&thread2, NULL, print_thread_id, NULL);
        if (ret1!=0)
        {
                printf("Error In Creating Thread with ID:%d\n",tid1);
        }
              
        pthread_exit(NULL); //Terminates the parent thread
}
