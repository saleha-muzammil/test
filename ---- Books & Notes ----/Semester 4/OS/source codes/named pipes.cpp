//C program to implement one side of FIFO
// This side writes first, then reads
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include<sys/wait.h>
#include <unistd.h>
#include<cstring>
#include<iostream>
#include <stdlib.h>
using namespace std;

int main()
{
    char ChannelStream[]="/home/oracle/Desktop";
    int res = mkfifo(ChannelStream, 0777);
    if(res==-1)
    {
         cout<<"Error!"<<endl;
    }
    int fd = open(ChannelStream, O_WRONLY);
    char arr1[4]={'1','2','3','4'};
    for(int i=0 ; i<580000 ;)
    {
           for(int j=0 ; j<5000 && i<580000 ; j++)
           {
              for(int k=0 ; k<29 && i<580000 ; k++)
              {
                  for(int l=0 ; l<4 && i<580000 ; l++)
                  {
                     int num=rand()%50;
                     write(fd,&num,sizeof(num));
                     i++;
                  }
              }
           }
           sleep(0.00025);
     }
     close(fd);
     
     fd = open(ChannelStream, O_RDONLY);
     for(int i=0 ; i<5800 ;)
     {
           for(int j=0 ; j<5000 && i<580000 ; j++)
           {
              for(int k=0 ; k<29 && i<580000 ; k++)
              {
                  for(int l=0 ; l<4 && i<580000 ; l++)
                  {
                     int num;
                     read(fd, &num,4);
                     cout<<num<<"   ";
                     i++;
                  }
              }
           }
           sleep(0.00025);
     }
     close(fd);
    return 0;
    }
