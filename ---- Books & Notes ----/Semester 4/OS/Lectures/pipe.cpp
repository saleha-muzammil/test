#include <iostream>
using namespace std;
#include <unistd.h>
#include <sys/wait.h>

int main()
{
  int fd[2];
  int status=pipe(fd);
  if (status==-1)
  {
    cout<<"Pipe Error";
    return 1;
  }

  status= fork();
  if (status==0)
  {
        close(fd[1]);
        char arr[100];
        int bytesRead=read(fd[0], arr, 100);
        close(fd[0]);

        cout<<"Parent Sent "<<bytesRead<<" bytes."<<endl;
        cout<<"Data Sent by parent: "<<arr<<endl;

  }

  else if (status>0)
  {

    close(fd[0]);
    write(fd[1],"Hello World", 12);
       close(fd[1]);
    wait(NULL);

 
   
  }
  else{

    cout<<"Fork Error";
    return 1;
  }

}