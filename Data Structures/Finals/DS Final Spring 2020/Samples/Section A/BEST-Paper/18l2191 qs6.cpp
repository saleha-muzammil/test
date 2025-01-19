#include<iostream>
using namespace std;

//template for generic type 
template<typename K, typename V>

//Hashnode class 
class HashNode
{
public:
	V value;
	K key;

	//Constructor of hashnode 
	HashNode(K key, V value)
	{
		this->value = value;
		this->key = key;
	}
};

//template for generic type 
template<typename K, typename V>

//Our own Hashmap class 
class HashMap
{
	//hash element array 
	HashNode<K, V>** arr;
	int capacity;
	//current size 
	int size;
	//dummy node 
	HashNode<K, V>* dummy;

public:
	HashMap()
	{
		//Initial capacity of hash array 
		capacity = 20;
		size = 0;

		arr = new HashNode<K, V> * [capacity];

		//Initialise all elements of array as NULL 
		for (int i = 0; i < capacity; i++)
			arr[i] = NULL;

		//dummy node with value and key -1 
		dummy = new HashNode<K, V>(-1, -1);
	}
	// This implements hash function to find index 
	// for a key 
	int hashCode(K key)
	{
		return key % capacity;
	}
	int getNextCandidateIndex(int key, int i)
	{
		int x = i * i;
		int index = (key + x) % this->capacity;
		return index;
	}
	//Function to add key value pair 
	void insertNode(K key, V value)
	{
		HashNode<K, V>* aux = new HashNode<K, V>(key, value);
		int a;
		// Apply hash function to find index for given key 
		int hashIndex = hashCode(key);

		cout << "HashIndex=" << hashIndex << endl;
		if(arr[hashIndex] != NULL && (arr[hashIndex]->key != key
			|| arr[hashIndex]->key != -1))
		{
			a=getNextCandidateIndex(key,1);//it will generate new hashindex for the insertion
			while (arr[a] != NULL && (arr[a]->key != key
				|| arr[a]->key != -1))//this while loop will check if the new generated is havig collision or not.
			{
				a=getNextCandidateIndex(key,2);
			}
			arr[a]=aux;
		}
		else
		{
			arr[hashIndex] = aux;
		}
		if (arr[hashIndex] == NULL || arr[hashIndex]->key == -1) {
			size++;//the lower if loop will check the size. if size greater or equal then it will double the capacity 
			/*if(size>=capacity)
			{
			doubleCapacity();
			}*/
		}


	}
	void doubleCapacity()//this function is for doubling the capacity of heap.
	{
		int x = capacity;
		capacity = capacity*2;
		HashNode<K, V>** temp = new HashNode<K, V>[capacity]();
		for(int i=0; i<x; i++)
			insertNode(arr[i]->key, arr[i]->value);

		this->arr=temp;
		delete [] temp;
	}
	//Function to delete a key value pair 
	V deleteNode(int key)
	{
		// Apply hash function to find index for given key 
		int hashIndex = hashCode(key);

		//finding the node with given key 
		while (arr[hashIndex] != NULL)
		{
			//if node found 
			if (arr[hashIndex]->key == key)
			{
				HashNode<K, V>* temp = arr[hashIndex];

				//Insert dummy node here for further use 
				arr[hashIndex] = dummy;

				// Reduce size 
				size--;
				return temp->value;
			}
			hashIndex++;
			hashIndex %= capacity;

		}

		//If not found return null 
		cout << "Key not found";
		return 0;
	}

	//Function to search the value for a given key 
	bool get(int key)
	{
		int k;
		// Apply hash function to find index for given key 
		int hashIndex = hashCode(key);
		int counter = 0;
		//finding the node with given key 
		while (arr[hashIndex] != NULL)
		{
			int counter = 0;
			if(counter<capacity)
			{
				//if node found return its value 
				if (arr[hashIndex]->key == key)
				{
					k = arr[hashIndex]->value;
					cout<<"Value at Key : "<<k<<endl;
					return true;
				}
			}
			else
			{
				return false;
			}
			hashIndex++;
			hashIndex %= capacity;
		}

		//If not found return -10 
		return false;
	}
	
	//Return current size 
	int sizeofMap()
	{
		return size;
	}

	//Return true if size is 0 
	bool isEmpty()
	{
		return size == 0;
	}

	//Function to display the stored key value pairs 
	void display()
	{
		for (int i = 0; i < capacity; i++)
		{
			if (arr[i] != NULL && arr[i]->key != -1)
				cout << "key = " << arr[i]->key
				<< " value = " << arr[i]->value << endl;
			//cout << i << endl;
		}
	}
};

//Driver method to test map class 
int main()
{
	HashMap<int, int>* h = new HashMap<int, int>;
	h->insertNode(1, 1);
	h->insertNode(3, 13);
	h->insertNode(2, 2);
	h->insertNode(2, 3);
	h->display();
	h->insertNode(3, 33);
	if(h->get(1))
	{
		cout<<"Key found"<<endl;
	}
	else
	{
		cout<<"Key not found"<<endl;
	}

	system("pause");
	return 0;
}