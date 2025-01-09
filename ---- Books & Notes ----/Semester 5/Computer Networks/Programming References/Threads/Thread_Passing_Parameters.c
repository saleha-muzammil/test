/*
This Program will pass the parameters from parent thread into child thread i.e., in this program we will pass the IDs of Threads
into the thread function via parent thread (main function)
*/

#include <stdio.h>
#include <pthread.h>

void *print_thread_id(void *message)
{
        char *tmsg = (char*)message;
        printf("%s\n",tmsg);
        pthread_exit(NULL);        
}

int main(void)
{
        char *message1="Thread 1";
        char *message2="Thread 2";

        pthread_t thread1, thread2;
        int ret1,ret2;
        
        ret1 = pthread_create(&thread1,NULL,print_thread_id,(void*)message1);
        if(ret1!=0)
        {
                printf("Thread 1 Creation Failed\n");
        }
        pthread_join(thread1,NULL); //Suspends main thread until termination of thread1
        
        ret2 = pthread_create(&thread2,NULL,print_thread_id,(void*)message2);
        if(ret2!=0)
        {
                printf("Thread 2 Creation Failed\n");
        }
        pthread_join(thread2,NULL);//Suspends main thread until termination of thread2
        
        pthread_exit(NULL);
}
