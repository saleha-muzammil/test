//Maham Basit 20L-1155 OS Lab Mid Q.1
#include<iostream>
using namespace std;
#include<sys/types.h>
#include<sys/wait.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>

int main()
{
   int fd1[2];    //child writes, parent reads
   int fd2[2];    //child reads, parent writes
   
   int status=pipe(fd1);                                             //creating pipe
   
   if(status==-1)
   {
      cout<<"Error in pipe Creation"<<endl;
      return 0;
   }
   else
   {
       status=fork();                                                //creating child
       if(status==-1)
       { 
           cout<<"Error in child creation"<<endl;
           return 0;
       }
       else if(status==0)                                               //child process
       {
          close(fd1[0]);                                                //close read end of file in child
          int ReadFromFile=open("data.txt", O_RDONLY,0);                //child reads from file data.txt
          char input[1000];
          int bytesRead=read(ReadFromFile, input,1000);
          write(fd1[1], input, bytesRead);                              //child writes to pipe
          close(fd1[1]);
          close(ReadFromFile);
       }
       else if(status>0)                                                //parent process
       {
          wait(NULL);                                                   //wait for child to write to pipe first
          close (fd1[1]);                                               //close write end in parent
          char input[1000];
          int bytesRead=read(fd1[0],input,1000);                        //parent readss from pipe
          close (fd1[0]);
          char alphabets[1000];
          char numbers[1000];
          int alphIndex=0, numIndex=0;
          for(int i=0; i<bytesRead; i++)                                //sepeartes alphabets and numbers in 2 arrays
          {
              if((input[i]>='a' && input[i]<='z') || (input[i] >='A' && input[i] <='Z'))
              {
                  alphabets[alphIndex++]=input[i];
              }
              else if(input[i]>='0' && input[i]<='9')
              {
                  numbers[numIndex++]=input[i];
              }
          }
          status=pipe(fd2);                                              //creates a new pipe for next child
          if(status==-1)
          {
             cout<<"Error in pipe Creation"<<endl;
             return 0;
          } 
          else
          {
              status=fork();
              if(status==-1)
              {
                 cout<<"Error in child creation"<<endl;
                 return 0;
              }
              else if(status>0)
              {
                 close(fd2[0]);                           //close read end in parent
                 write(fd2[1], numbers, numIndex);        //write numbers in pipe first
                 write(fd2[1], alphabets, alphIndex);     //write alphabets then in pipe
                 close(fd2[1]);
                 wait(NULL);
              }
              else if(status==0)
              {
                 close(fd2[1]);                              //close write end in child
                 char input[1000];
                 int bytesRead=read(fd2[0], input, 1000);    //read from pipe
                 cout<<"Data written to file: ";
                 for(int i=0; i<bytesRead; i++)              //cout data we are writing to file for checking
                    cout<<input[i];
                 cout<<endl<<"Bytes written to file: "<<bytesRead<<endl;
                 
                 int WriteToFile=open("dataWrite.txt", O_WRONLY | O_CREAT ,0777);     //write to file
                 write(WriteToFile, input, bytesRead);
                 close(WriteToFile);
              }
          }    
          
       }

   }
   return 0;
}
