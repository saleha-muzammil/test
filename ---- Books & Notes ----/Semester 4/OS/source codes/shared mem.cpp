#include <iostream>
using namespace std;
#include <sys/shm.h>
#include <string>
#include <sys/shm.h>

double findMean(int num[], int n)
{
    int sum = 0;
    for (int i = 0; i < n; i++)
        sum += num[i];

    return (double)sum / (double)n;
}

double findMedian(int num[], int n)
{
    // check for even case
    if (n % 2 != 0)
        return (double)num[n / 2];

    return (double)(num[(n - 1) / 2] + num[n / 2]) / 2.0;
}

int findMode(int arr[], int n)
{

    int max_count = 1, res = arr[0], count = 1;
    for (int i = 1; i < n; i++) {
        if (arr[i] == arr[i - 1])
            count++;
        else
        {
            if (count > max_count)
            {
                max_count = count;
                res = arr[i - 1];
            }
            count = 1;
        }
    }

    // when the last element is most frequent
    if (count > max_count)
    {
        max_count = count;
        res = arr[n - 1];
    }

    return res;
}


int main()
{
    int key = shmget(12356, 1024, IPC_CREAT | IPC_EXCL | 0666); //12321 is the user key// 1024 is the bytes we want to use as shared memory

    int* ptr = (int*)shmat(key, NULL, 0);

    cout << "shm created with id= " << key << endl;
    ptr[0] = -1;

    cout << "Waiting for the client process to send data.!" << endl;
    while (ptr[0] == -1); //busy wait

    cout << endl << "Numbers Read in Server:" << endl;

    for (int i = 0; i < 5; i++)
    {
        cout << ptr[i] << endl;
    }

    cout << "Mean = " << findMean(ptr, 5) << endl;
    cout << "Median = " << findMedian(ptr, 5) << endl;
    cout << "Mode = " << findMode(ptr, 5) << endl;

    //detach
    shmdt(ptr);

    shmctl(key, IPC_RMID, NULL); //mark the shared region for deletion
}
