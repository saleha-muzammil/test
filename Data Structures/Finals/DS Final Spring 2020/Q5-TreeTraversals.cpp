#include <iostream>
#include<vector>
#include <stack>
#include <chrono>
using namespace std;
using namespace std::chrono;

struct Node {
	int data;
	Node* left;
	Node* right;

	Node() {
		data = 0;
		left = 0;
		right = 0;
	}

	Node(int d) {
		data = d;
		left = 0;
		right = 0;
	}
};


//https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/
void postOrder_rec(Node* node)
{
	if (node == NULL)
		return;

	// first recur on left subtree 
	postOrder_rec(node->left);

	// then recur on right subtree 
	postOrder_rec(node->right);

	// now process this node 
	//cout << node->data << " ";
}

//https://www.geeksforgeeks.org/iterative-postorder-traversal-using-stack/
void postOrder_iter(Node* root)
{
	if (root == NULL)
		return;

	stack<Node*> nodeStack;
	do
	{
		// Move to leftmost node 
		while (root)
		{
			// Push root's right child and then root to stack. 
			if (root->right)
				nodeStack.push(root->right);
			nodeStack.push(root);

			// Set root as root's left child   
			root = root->left;
		}

		// Pop an item from stack and set it as root     
		root = nodeStack.top();
		nodeStack.pop();

		Node* top = NULL;
		if (!nodeStack.empty())
			top = nodeStack.top();
		// If the popped item has a right child and the right child is not 
		// processed yet, then make sure right child is processed before root 
		if (root->right && top == root->right)
		{
			nodeStack.pop();  		// remove right child from stack 
			nodeStack.push(root);	// push root back to stack 
			root = root->right; 	// change root so that the right  
									// child is processed next 
		}
		else  // Else print root's data and set root as NULL 
		{
			//cout<<root->data<<" ";
			root = NULL;
		}
	} while (!nodeStack.empty());
}


//https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/
void inOrder_rec(Node* node)
{
	if (node == NULL)
		return;

	// first recur on left child
	inOrder_rec(node->left);

	// then process this node
	//cout << node->data << " ";

	// now recur on right child
	inOrder_rec(node->right);
}

//https://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion/
void inOrder_iter(Node* root)
{
	stack<Node*> nodeStack;
	Node* curr = root;

	while (curr != NULL || !nodeStack.empty()) {
		// Reach the left most Node of the curr Node
		while (curr != NULL) {
			// Place pointer to a tree node on the stack before traversing the node's left subtree
			nodeStack.push(curr);
			curr = curr->left;
		}

		// Current must be NULL at this point
		curr = nodeStack.top();
		nodeStack.pop();

		//cout << curr->data << " ";

		// We have visited the node and its left subtree.  Now, it's right subtree's turn
		curr = curr->right;
	}
}


//https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/
void preOrder_rec(Node* node)
{
	if (node == NULL)
		return;

	// first process this node
	//cout << node->data << " ";

	// then recur on left sutree
	preOrder_rec(node->left);

	// now recur on right subtree
	preOrder_rec(node->right);
}

//https://www.geeksforgeeks.org/iterative-preorder-traversal/
void preOrder_iter(Node* root)
{
	if (root == NULL)
		return;

	stack<Node*> nodeStack;
	nodeStack.push(root);

	while (!nodeStack.empty()) {
		Node* node = nodeStack.top();
		//cout<<node->data<<" ";
		nodeStack.pop();

		if (node->right)
			nodeStack.push(node->right);
		if (node->left)
			nodeStack.push(node->left);
	}
}


void populateTree(Node*& root, int inputSize) {

	vector<Node*> queue;

	root = new Node(1);
	queue.push_back(root);

	for (int i = 2; i <= inputSize;) {
		Node* node = queue.at(0);
		queue.erase(queue.begin());

		Node* newNode = new Node(i++);
		node->left = newNode;
		queue.push_back(node->left);

		if (i > inputSize)
			break;

		newNode = new Node(i++);
		node->right = newNode;
		queue.push_back(node->right);
	}
}

int main()
{
	high_resolution_clock::time_point STARTING_TIME, ENDING_TIME;
	nanoseconds TIME_SPAN;

	Node* root;
	/* Use these lines for populating Input*/
	populateTree(root, 10);
	//populateTree(root, 50);
	//populateTree(root, 500);


	//  Recursive Inorder     
	STARTING_TIME = high_resolution_clock::now();
	inOrder_rec(root);
	ENDING_TIME = high_resolution_clock::now();
	TIME_SPAN = duration_cast<nanoseconds>(ENDING_TIME - STARTING_TIME);
	cout << "Inorder     Recursive: " << TIME_SPAN.count() << "   ";

	//  Iterative Inorder     
	STARTING_TIME = high_resolution_clock::now();
	inOrder_iter(root);
	ENDING_TIME = high_resolution_clock::now();
	TIME_SPAN = duration_cast<nanoseconds>(ENDING_TIME - STARTING_TIME);
	cout << "Iterative: " << TIME_SPAN.count() << endl;
	


	//  Recursive Preorder
	STARTING_TIME = high_resolution_clock::now();
	preOrder_rec(root);
	ENDING_TIME = high_resolution_clock::now();
	TIME_SPAN = duration_cast<nanoseconds>(ENDING_TIME - STARTING_TIME);
	cout << "Preorder    Recursive: " << TIME_SPAN.count() << "   ";

	//  Iterative Preorder
	STARTING_TIME = high_resolution_clock::now();
	preOrder_iter(root);
	ENDING_TIME = high_resolution_clock::now();
	TIME_SPAN = duration_cast<nanoseconds>(ENDING_TIME - STARTING_TIME);
	cout << "Iterative: " << TIME_SPAN.count() << endl;



	//  Recursive Postorder
	STARTING_TIME = high_resolution_clock::now();
	postOrder_rec(root);
	ENDING_TIME = high_resolution_clock::now();
	TIME_SPAN = duration_cast<nanoseconds>(ENDING_TIME - STARTING_TIME);
	cout << "Postorder   Recursive: " << TIME_SPAN.count() << "   ";

	//  Iterative Postorder
	STARTING_TIME = high_resolution_clock::now();
	postOrder_iter(root);
	ENDING_TIME = high_resolution_clock::now();
	TIME_SPAN = duration_cast<nanoseconds>(ENDING_TIME - STARTING_TIME);
	cout << "Iterative: " << TIME_SPAN.count() << endl;

	return 0;
}