/*
        This Program will return a structure populated with some data from child thread into parent thread using a
        combination of pthread_exit and pthread_join. The child thread will pass the structure pointer into pthread_exit
        and parent thread will save that value in a struct pointer using pthread_join function.
*/

#include <stdio.h>
#include <pthread.h>
#include <string.h>

struct thread_struct
{
        char t_msg[50];
        int tid;
};

//Global Structure Instance
struct thread_struct t_str;

void* thread_struct_manipulation (void *arg)
{
        struct thread_struct *t_mani = (struct thread_struct *)arg;
        strcat(t_mani->t_msg,". Hi I am manipulated Thread ");
        t_mani->tid=t_mani->tid+1;
        pthread_exit((void*)t_mani);
        
}
 
int main(void)
{
        pthread_t thread;
        struct thread_struct *t_mani;

        strcpy(t_str.t_msg,"Hi i am Thread");
        t_str.tid=2;
        printf("Before: %s %d\n",t_str.t_msg,t_str.tid);
        pthread_create(&thread,NULL,thread_struct_manipulation,(void*)&t_str);
        pthread_join(thread,(void**)&t_mani);//Suspends the function until the thread completes and return the data
        printf("After: %s %d\n",t_mani->t_msg,t_mani->tid);
        pthread_exit(NULL);
}

