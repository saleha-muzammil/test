#include <iostream>
using namespace std;
#include "DLinkList.h"
#include <vector>
int main()
{
	DLinkList<int> list;
	list.insertAtHead(10);
	list.insertAtHead(100);
	list.insertAtTail(0);

	/*traversing our doubly linked list using the iterator class implemented
	  inside the linked list.*/
	for (DLinkList<int>::Iterator it = list.begin(); it != list.end(); ++it)
	{
		cout << *it<<", ";
	}


	//iterators for vector available in vector class
	//vector<int> a;
	//a.push_back(10);
	//a.push_back(20);
	//a.push_back(30);
	//a.push_back(50);

	////reverse iterator for vector
	//for (std::vector<int>::reverse_iterator it = a.rbegin(); it != a.rend(); it++)
	//{
	//	cout << *it << endl;
	//}

	////forward iterator for vector
	//for (std::vector<int>::iterator it = a.begin(); it != a.end(); it++)
	//{
	//	cout << *it << endl;
	//}
}