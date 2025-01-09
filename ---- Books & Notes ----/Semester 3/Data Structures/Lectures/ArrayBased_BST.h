#pragma once

#include <iostream>
using namespace std;
#include <assert.h>

template <typename k, typename v>
struct TreeItem
{
	k key;
	v value;
	bool isOccupied;

	TreeItem()
	{
		isOccupied = false;
	}
};

template <typename k, typename v>
class BinarySearchTree
{
private:
	TreeItem<k,v>* arr;
	int capacity;
	int totalElements;

	void inOrderPrintKeys(int i) const
	{
		if (i >= capacity || !this->arr[i].isOccupied)
			return;
		else
		{
			inOrderPrintKeys(i * 2 + 1);
			cout << this->arr[i].key<<endl;
			inOrderPrintKeys(i * 2 + 2);
		}
	}

	void doubleCapacity()
	{
		TreeItem<k, v>* oldArr = arr;
		this->arr = new TreeItem<k, v>[this->capacity * 2];
		for (int i = 0; i < this->capacity; i++)
		{
			if (oldArr[i].isOccupied==true)
			this->arr[i] = oldArr[i];
		}

		delete []oldArr;
		this->capacity *= 2;
	}
public:
	BinarySearchTree(int _capacity=1)
	{
		assert(_capacity > 0);
		this->arr = new TreeItem<k,v>[_capacity];
		this->capacity = _capacity;
		this->totalElements = 0;
	}

	v const* search(k _key) const
	{
		for (int i = 0; i < this->capacity; )
		{
			if (arr[i].isOccupied == false)
			{
				return nullptr;
			}
			else if (_key < arr[i].key)
			{
				i = i * 2 + 1;
			}
			else if (_key > arr[i].key)
			{
				i = i * 2 + 2;
			}
			else return &this->arr[i].value;
		}
	}

	
	void insert(k _key, v _value)
	{
		for (int i = 0; i < this->capacity;)
		{
			if (arr[i].isOccupied == false)
			{
				arr[i].key = _key;
				arr[i].value = _value;
				arr[i].isOccupied = true;
				this->totalElements++;
				break;
			}
			else if (_key < arr[i].key)
			{
				i = i * 2 + 1;
			}
			else if (_key > arr[i].key)
			{
				i = i * 2 + 2;
			}
			else return; //key already exists
			
			if (i >= this->capacity)
			{
				this->doubleCapacity();
			}

		}
	}

	void delete_(k _key)
	{
		for (int i = 0; i < this->capacity;)
		{
			if (arr[i].isOccupied == false)
			{
				break;
			}
			else if (_key < arr[i].key)
			{
				i = i * 2 + 1;
			}
			else if (_key > arr[i].key)
			{
				i = i * 2 + 2;
			}
			else
			{    //leaf case
				if ( (i*2+1 >= this->capacity ||  this->arr[i * 2 + 1].isOccupied == false) && (i*2+2 >=this->capacity || this->arr[i * 2 + 2].isOccupied == false))
				{
					this->arr[i].isOccupied = false;
				}
				//only left child exists
				else if (i*2+1 < this->capacity && this->arr[i * 2 + 1].isOccupied == false)
				{
					percolateUp(i * 2 + 1, i); 
				}

				//only right child exists
				else if (i * 2 + 2 < this->capacity && this->arr[i*2+2].isOccupied==false)
				{
					percolateUp(i * 2 + 2, i);
				}

				else //both children exist, find an inorder sucessor from right subtree
				{
					int successor = i * 2 + 2;
					while (this->arr[successor * 2 + 1].isOccupied == true)
						successor = successor * 2 + 1;
					this->arr[i] = this->arr[successor];
					this->arr[successor].isOccupied = false;
					percolateUp(successor * 2 + 2, successor);
				}
				this->totalElements--;
			}

		}//end of for loop
	}//end of delete_ function

	void percolateUp(int originalIndex, int newIndex)
	{
		if (originalIndex>=this->capacity || this->arr[originalIndex].isOccupied == false)
			return;

		this->arr[newIndex] = this->arr[originalIndex];
		this->arr[originalIndex].isOccupied = false;

		percolateUp(originalIndex * 2 + 1, newIndex * 2 + 1);
		percolateUp(originalIndex * 2 + 2, newIndex * 2 + 2);
	}

	void inOrderPrintKeys() const
	{
		this->inOrderPrintKeys(0);
	}

	~BinarySearchTree()
	{
		delete []this->arr;
	}

};