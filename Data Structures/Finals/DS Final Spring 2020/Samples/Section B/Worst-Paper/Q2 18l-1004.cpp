#include"pch.h"
#include<iostream>
#include<stack>
#include<string>
string removepairs(string input)
{
	stack<char> stack1;
	stack<char> stack2;
	char a = '\0';
	int len = 0;
	while (input[len] != '\0')
		len++;
	a = input[0];
	stack1.push(a);
	char b = '\0';
	for (int i = 1; i < len; i++)
	{
		a = input[i];
		while (!stack1.empty())
		{
			b = stack1.top();
			stack1.pop();
			if (a == b)
				break;
			else
			{
				stack2.push(b);
			}
		}
		while (!stack2.empty())
		{
			b = stack2.top();
			stack2.pop();
			stack1.push(b);
		}
		stack1.push(a);
	}
	string output = "";
	while (!stack1.empty())
	{
		a = stack1.top();
		stack1.pop();
		output += a;
	}
	return output;
}
using namespace std;
int main()
{
	cout << removepairs("sadness");
	system("pause");
	return 0;
}
//time complexity = O(n)