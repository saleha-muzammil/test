/*
        This Program will create the threads using an array of threads and passing their corresponding structure into the
        Thread Function using pthread_create function
*/

#include <stdio.h>
#include <pthread.h>
#include <string.h>

struct thread_struct
{
        char t_msg[50];
        int tid;        
};

void *print_thread_info (void *thread_struct)
{
        struct thread_struct *t_st = (struct thread_struct*)thread_struct;
        printf("%s",t_st->t_msg);
        printf("%d\n",t_st->tid);    
        pthread_exit(NULL);
}

int main(void)
{
        pthread_t thread[10];
        
        struct thread_struct thread_st[10];
        int i=0;
        
        for(i=0;i<10;i++)//Populating the thread structures with raw data
        {
                strcpy(thread_st[i].t_msg,"Hi I am thread ");
                thread_st[i].tid=i+1;
        }
        
        for(i=0;i<10;i++)
        {
                pthread_create(&thread[i],NULL,print_thread_info,(void*)&thread_st[i]); 
                pthread_join(thread[i],NULL);//Suspend the creation of next thread until the preceding thread is completed
        }       
               
        pthread_exit(NULL);      
}
