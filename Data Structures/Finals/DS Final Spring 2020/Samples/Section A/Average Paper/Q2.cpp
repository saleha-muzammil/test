#include <iostream>
#include <string>

#define max 1000

class Stack
{
	int top;
public:
	char stk[max];
	Stack()
	{
		top = -1;
	}
	bool isStackEmpty();
	void push(char);
	char pop();
	std::string modifyString(std::string);
private:
	void removeAdjacentDuplicate(std::string);
};

bool Stack::isStackEmpty()
{
	if (top == -1)
		return true;
	else
		return false;
}

void Stack::push(char val)
{
	int s = max - 1;
	if (top < s)
	{
		top = top + 1;
		stk[top] = val;
	}
	else
		std::cerr << "Stack Overflow \n";
}

char Stack::pop()
{
	if (isStackEmpty() == true)
		std::cerr << "Stack Underflow \n";
	else
	{
		--top;
		return stk[top + 1];
	}
}

void Stack::removeAdjacentDuplicate(std::string str)
{
	int len = str.length();
	for (int i = 0; i < len; i++)
	{
		if (isStackEmpty() == true)
		{
			push(str[i]);
		}
		else if (str[i] == stk[top])
		{
			int discard = pop();
		}
		else
		{
			push(str[i]);
		}
	}
}

std::string Stack::modifyString(std::string str)
{
	removeAdjacentDuplicate(str);
	str.resize(top + 1);
	for (int i = 0; i <= top; i++)
	{
		str[i] = stk[i];
	}
	str[top + 1] = '\0';
	return str;
}

int main()
{
	Stack stack1;
	std::string str = "careermonk";
	std::cout << "Orignal string : " << str << "\n";
	str = stack1.modifyString(str);
	std::cout << "New string     : " << str << "\n";

	Stack stack2;
	std::string str2 = "mississippi";
	std::cout << "Original string : " << str2 << "\n";
	str2 = stack2.modifyString(str2);
	std::cout << "New string      : " << str2 << "\n";

	Stack stack3;
	std::string str3 = "pacific ocean";
	std::cout << "Original string : " << str3 << "\n";
	str3 = stack3.modifyString(str3);
	std::cout << "New string      : " << str3 << "\n";
	system("pause");
}
