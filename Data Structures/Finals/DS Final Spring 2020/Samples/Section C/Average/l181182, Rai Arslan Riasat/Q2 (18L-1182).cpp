#include<iostream>
#include<string>
#include<fstream>
using namespace std;
template <typename t>
class stack
{
	t* arr;
	int top;
public:
	stack()
	{
		top = -1;
		arr = new t[100];
	}
	t* getarr()
	{
		return arr;
	}
	int gettop()
	{
		return top;
	}
	bool isEmpty()
	{
		if (top == -1)
		{
			return 1;
		}
		else
			return 0;
	}
	void push(t& e)
	{
		arr[++top] = e;
	}
	void pusha(char e)
	{
		arr[++top] = e;
	}
	t pop()
	{
		if (isEmpty())
		{
//			cout << "Stack is Empty";
			exit(1);
		}
		else
		{
			t num = arr[top];
			//			cout << "Poped element is :\n" << num;
			top--;
			return num;
		}
	}
	string removePairs(string input)
	{
		stack <char> stack1;
		stack <char> stack2;
		string output;
		char a, b;
		for (int i = 0; i < input.size(); i++)
		{
			stack1.push(input[i]);
		}
		for (int i = 0; i < input.size(); i++)
		{
			a = stack1.pop();
			while (!stack1.isEmpty())
			{
				b = stack1.pop();
				if (a == b)
				{
					break;
				}
				else
				{
					stack2.push(b);
				}
			}
			if (stack1.isEmpty())
			{
				output += a;
			}
			while (!stack2.isEmpty())
			{
				b = stack2.pop();
				stack1.push(b);
			}
		}

		return output;
	}
	~stack()
	{
		delete[] arr;
	}
};
int main()
{
	stack<char>obj;
	cout << obj.removePairs("Rai Arslan Riasat");

	return 0;
}