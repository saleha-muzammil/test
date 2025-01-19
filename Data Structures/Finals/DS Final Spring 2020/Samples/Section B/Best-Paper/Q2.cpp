#include<iostream>
#include<stack>
#include<string>
using namespace std;
string removepairs(string input);
int main()
{
	string s;
	cin >> s;
	cout<<removepairs(s);
	system("pause");
	return 0;
}
string removepairs(string input)
{
	stack<char> stack1;
	stack<char> stack2;
	char a = '\0';
	int len = 0;
	while (input[len] != '\0')
		len++;
	a = input[len-1];
	stack1.push(a);
	char b = '\0';
	bool flag = false;
	for (int i = len-2; i >=0; i--)
	{
		a = input[i];
		flag = false;
		while (!stack1.empty())
		{
			b = stack1.top();
			stack1.pop();
			if (a == b)
			{
				flag = true;
				break;
			}
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
		if(a!=b && !flag)
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