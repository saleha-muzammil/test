#include <iostream>
using namespace std;


struct hashitem
{
	int value;
	int key;
	hashitem*next;
};

class hashtable
{
	int size;
	hashitem * Array;

	public:
		hashtable(int n)
		{
			size=n;
			Array=new hashitem[size];

			for(int i=0;i<size;i++)
			{
				Array[i].next=nullptr;
				Array[i].value=-1;
			}
		}

		int hashkey(int num)
		{
			return num%size;
		}
		int quadhash(int index,int &j)
		{
			j++;
			return index+(j*j);
		}
		void insert(int *arr,int n)
		{
			for(int i=0;i<n;i++)
			{
				int index=hashkey(arr[i]);
				if(Array[index].value==-1)
				{
					Array[index].value=arr[i];
					Array[index].key=index;
				}

				else
				{
					int parent=index;
					int j=0;
					int INDEX=quadhash(index,j);
					if(Array[INDEX].value==-1)
					{
						Array[INDEX].value=arr[i];
						Array[INDEX].key=INDEX;
						Array[parent].next=&Array[INDEX];		//contains address of same with key indexationssszzzzzzzzz
					}
					else
					{
						bool flag=false;
						while(flag==false)
						{
						//re-index already element
						parent=INDEX;
						INDEX=quadhash(INDEX,j);
							if(Array[INDEX].value==-1)
							{
								Array[INDEX].value=arr[i];
								Array[INDEX].key=INDEX;
								Array[parent].next=&Array[INDEX];		//contains address of same with key indexationssszzzzzzzzz
								flag=true;
							}						
						}
					}
				}
			}
		}
		bool Search(int num)
		{
			bool flag=false;
			int key=hashkey(num);
			if(Array[key].value==num)
				return true;
			else
			{
				if(Array[key].next!=nullptr)
				{						int j=0;
						int INDEX=quadhash(INDEX,j);
				while(flag==false && INDEX!=key)
					{

						if(Array[INDEX].value==num)
						{
								return true;	
								flag=true;
						}						
					}
				}
			}
		}
};


//WORST case
// when rehashing to same of the values in a loop bound infinity loops shall work both for INSERTION , SEARCHING ALSO INFINITY LOOPINGS

