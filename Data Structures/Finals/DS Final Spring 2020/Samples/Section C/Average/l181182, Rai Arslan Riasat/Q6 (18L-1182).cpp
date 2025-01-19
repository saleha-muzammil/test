#include<iostream>
#include<assert.h>
using namespace std;
struct hashitem
{
	int value;
	short status;
	hashitem * next;
	hashitem()
	{
		status = 0;
		next = NULL;
	}
};
// Status tell us that if slot is empty or not..
class HashMap
{
private:
	hashitem* hashArray;
	int capacity;
	int currentElements;
	int getNextCandidateIndex(int key, int i)
	{
		if (i > capacity)
		{
			return_double();
			i = 1;
		}
		if (key + (i * i) == capacity - 1)
		{
			return 0;
		}
		if (key + (i * i) > capacity)
		{
			return (key + (i * i)) % capacity;
		}
		return key + (i * i);
	}
	void double_cap()
	{
		capacity = capacity * 2;
		hashitem * temp = new hashitem[capacity];
		int j = 0;
		for (int i = 0; i < currentElements && j < capacity; j++)
		{
			if (hashArray[j].status == 2)
			{
				temp[j].value = hashArray[j].value;
				temp[j].status = 2;
				i++;
			}

		}
		delete[] hashArray;
		hashArray = new hashitem[capacity];
		j = 0;
		for (int i = 0; i < currentElements && j < capacity; j++)
		{
			if (temp[j].status == 2)
			{
				
				hashArray[j].value = temp[j].value;
				hashArray[j].status = 2;
				i++;
			}
		}
	}

public:

	HashMap()
	{
		capacity = 10;
		hashArray = new hashitem[capacity];
		currentElements = 0;
	}
	HashMap(int const cap)
	{
		assert(cap < 1);

		capacity = cap;
		hashArray = new hashitem[capacity];
		currentElements = 0;

	}
	void return_double()
	{
		this->double_cap();
	}
	void insert(int const data)
	{
		if (currentElements != capacity - capacity / 4)
		{
			int index = data % capacity;
			int i = 1;
			if (hashArray[index].status == 2)
			{
				int prev_index = index;
				while (hashArray[index].status == 2)
				{
					index = getNextCandidateIndex(index, i++);
				}
				if (hashArray[prev_index].next != NULL)
				{
					hashitem* temp = hashArray[prev_index].next;
					while(temp->next)
					{
						temp = temp->next;
					}
					temp->next = &hashArray[index];
				}
				else
				{
					hashArray[prev_index].next = &hashArray[index];
				}

			}
			hashArray[index].value = data;
			hashArray[index].status = 2;
			hashArray[index].next = NULL;
			currentElements++;
		}
		else
		{
			double_cap();
		}
	}
	bool search(int key)
	{
		int index = key % currentElements;
		hashitem * temp = hashArray[index].next;
		while (temp && temp->value != key)
		{
			temp = temp->next;
		}
		if (temp==NULL)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
};
int main()
{
	HashMap obj;
	obj.insert(20);
	obj.insert(35);
	obj.insert(16);
	obj.insert(40);
	obj.insert(45);
	obj.insert(25);
	obj.insert(32);
	obj.insert(37);
	obj.insert(22);
	obj.insert(55);
	cout << obj.search(25);
	system("pasue");
}


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

	//Function to add key value pair 
	void insertNode(K key, V value)
	{
		HashNode<K, V>* temp = new HashNode<K, V>(key, value);

		// Apply hash function to find index for given key 
		int hashIndex = hashCode(key);

		cout << "HashIndex=" << hashIndex << endl;
		//cout << arr[hashIndex];

		//find next free space 
		while (arr[hashIndex] != NULL && (arr[hashIndex]->key != key
			|| arr[hashIndex]->key != -1))
		{
			//cout<<"WHILE true";
			hashIndex++;
			//cout << "hashIndex =" << hashIndex; 

			hashIndex %= capacity;
			//cout <<"hashIndex %= capacity ="<< hashIndex;

		}

		//if new node to be inserted increase the current size 
		if (arr[hashIndex] == NULL || arr[hashIndex]->key == -1) {
			//hashIndex++; 
			//hashIndex %= capacity;
			//cout <<"if new node to be inserted increase the current size";	
			size++;

		}

		arr[hashIndex] = temp;
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
				return arr[hashIndex]->value;
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
	//h->display(); 
	h->insertNode(3, 13);
	h->insertNode(2, 2);
	//h->display(); 
	h->insertNode(2, 3);
	h->display();

	//h->display(); 
	h->insertNode(3, 33);

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