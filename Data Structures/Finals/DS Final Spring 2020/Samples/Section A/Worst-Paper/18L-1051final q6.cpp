#include<iostream>
using namespace std;

//template for generic type 
template<typename K>

//Hashnode class 
class HashNode
{
public:
	     K key;
		 int hashkey;
		 int next;

	//Constructor of hashnode 
	HashNode(K value)
	{
		hashkey = -1;
		this->key = value;
		next = nullptr;
	}
};

//template for generic type 
template<typename K, typename V>

//Our own Hashmap class 
class HashMap
{
	//hash element array 
	HashNode<K>** arr;
	int capacity;
	//current size 
	int size;
	//dummy node 
	HashNode<K>* dummy;

public:
	HashMap()
	{
		//Initial capacity of hash array 
		capacity = 20;
		size = 0;

		arr = new HashNode<K, V> *[capacity];

		//Initialise all elements of array as NULL 
		for (int i = 0; i < capacity; i++)
			arr[i] = NULL;

		//dummy node with value and key -1 
		dummy = new HashNode<K, V>(-1);
	}
	// This implements hash function to find index 
	// for a key 
	int hashCode(K key)
	{
		return key % capacity;
	}

	//Function to add key value pair 
	void insertNode(K key)
	{
		HashNode<K, V>* temp = new HashNode<K, V>(key);

		// Apply hash function to find index for given key 
		int hashIndex = hashCode(key);
		temp->value = hashIndex;
		cout << "HashIndex=" << hashIndex << endl;
		int i = 0;
		//find next free space 
		while (arr[hashIndex] != NULL && (arr[hashIndex]->key != key || arr[hashIndex]->key != -1))
		{
			int nextvalueindex = hashIndex;
			i++;
			hashIndex = (key + (i*i)) % get_capacity();
			temp->hashkey = hashIndex;
			arr[nextvalueindex]->next = hashindex;
		}

		//if new node to be inserted increase the current size 
		if (arr[hashIndex] == NULL || arr[hashIndex]->key == -1) 
		{
			size++;
		}

		arr[hashIndex] = temp;
	}
	bool search(K key)
	{
		bool flag = false;
		for (int i = 0; i < capacity; i++)
		{
			if (hashArray[i]->key == key)
			{
				flag = true;
			}
		}
		return flag;
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
				HashNode<K>* temp = arr[hashIndex];

				//Insert dummy node here for further use 
				arr[hashIndex] = dummy;

				// Reduce size 
				size--;
				return temp->hashkey;
			}
			hashIndex++;
			hashIndex %= capacity;

		}

		//If not found return null 
		cout << "Key not found";
		return 0;
	}

	//Function to search the value for a given key 
	V get(int key)
	{
		// Apply hash function to find index for given key 
		int hashIndex = hashCode(key);
		int counter = 0;
		//finding the node with given key 
		while (arr[hashIndex] != NULL)
		{
			int counter = 0;
			if (counter++ > capacity) //to avoid infinite loop 
				return -20;
			//if node found return its value 
			if (arr[hashIndex]->key == key)
				return arr[hashIndex]->hashkey;
			hashIndex++;
			hashIndex %= capacity;
		}

		//If not found return -10 
		return -10;
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
				<< " value = " << arr[i]->hashkey << endl
				<< " next   =  " << arr[i]->next << endl;

			//cout << i << endl;
		}
	}
};

//Driver method to test map class 
int main()
{
	HashMap<int, int>* h = new HashMap<int, int>;
	h->insertNode(20);
	//h->display(); 
	h->insertNode(35);
	h->insertNode(16);
	//h->display(); 
	h->insertNode(40);
	h->display();

	//h->display(); 
	h->insertNode(3);

	cout << "h->sizeofMap()" << endl;
	cout << h->sizeofMap() << endl;
	cout << "h->display()";
	h->display();

	cout << h->deleteNode(2) << endl;
	cout << "h->sizeofMap()" << endl;
	cout << h->sizeofMap() << endl;
	h->display();
	cout << h->isEmpty() << endl;

	cout << h->get(2) << endl;

	system("pause");
	return 0;
}
