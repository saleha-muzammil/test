#pragma once
#include <iostream>
using namespace std;
#include <assert.h>

template <typename T>
struct DNode
{
	T data;
	DNode* next;
	DNode* prev;
};

template <typename T>
class DLinkList
{
	DNode<T>* head;
	DNode<T>* tail;
	int totalElements;

public:
	class Iterator;
	DLinkList<T>::Iterator begin() const
	{
		Iterator it(this->head);
		return it;
	}

	DLinkList<T>::Iterator end() const
	{
		Iterator it;
		return it;
	}

	class Iterator
	{
	private:
		DNode<T>* curr;
	
	public:
		Iterator()
		{
			curr = nullptr;
		}

		Iterator(Iterator const& that)
		{
			this->curr = that.curr;
		}

		Iterator(DNode<T> *ptr)
		{
			this->curr = ptr;
		}

		T& operator*()
		{
			assert(this->curr != nullptr);
			return this->curr->data;
		}

		bool operator!=(DLinkList<T>::Iterator that)const
		{
			return (this->curr != that.curr);

		}
		

		Iterator& operator++()
		{
			assert(this->curr != nullptr);

			this->curr = curr->next;
			return *this;

		}
		
		Iterator operator++(int)
		{
			assert(this->curr != nullptr);
			Iterator newIterator(*this);

			this->curr = curr->next;
			return newIterator;
		}
	};


	DLinkList()
	{
		this->head = this->tail = nullptr;
		this->totalElements = 0;
	}

	bool isEmpty()
	{
		return !this->head;
	}

	void insertAtHead(T data)
	{

		if (isEmpty())
		{
			DNode<T>* newNode = new DNode<T>;
			newNode->data = data;
			newNode->next = nullptr;
			newNode->prev = nullptr;
			this->head = this->tail = newNode;
			totalElements++;
		}
		else
		{
			DNode<T>* newNode = new DNode<T>;
			newNode->data = data;
			newNode->next = this->head;
			newNode->prev = nullptr;
			this->head->prev = newNode;
			this->head = newNode;
			totalElements++;
		}
	}

	void insertAtTail(T data)
	{
		if (isEmpty())
		{
			DNode<T>* newNode = new DNode<T>;
			newNode->next = newNode->prev = nullptr;
			newNode->data = data;
			this->head = this->tail = newNode;
			this->totalElements++;
		}
		else
		{
			DNode<T>* newNode = new DNode<T>;
			newNode->data = data;
			newNode->next = nullptr;
			newNode->prev = this->tail;
			this->tail->next = newNode;
			this->tail = newNode;
			this->totalElements++;
		}
	}

	void deleteFromTail()
	{
		if (isEmpty())
		{
			return;
		}

		if (this->head == this->tail)
		{
			delete head;
			this->head = this->tail = nullptr;
			this->totalElements--;
		}
		else
		{
			DNode<T>* delNode = this->tail;
			tail = tail->prev;
			tail->next = nullptr;
			delete delNode;
			this->totalElements--;
		}
	}

	void deleteFromHead()
	{
		if (isEmpty())
		{
			return;
		}

		if (this->head == this->tail)
		{
			delete head;
			this->head = this->tail = nullptr;
			this->totalElements--;
		}

		else
		{
			DNode<T>* delNode = this->head;
			head = head->next;
			head->prev = nullptr;
			delete delNode;
			this->totalElements--;
		}
	}

	void print()
	{
		DNode<T>* tmp = head;
		while (tmp)
		{
			cout << tmp->data << endl;
			tmp = tmp->next;
		}
	}

	~DLinkList()
	{
		DNode<T>* ptr = this->head;
		while (head)
		{
			ptr = ptr->next;
			delete head;
			head = ptr;
		}

	}
};