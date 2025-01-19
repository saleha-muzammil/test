#include <iostream>
#include <stack>
#include <string>
using namespace std;
string removePairs(string input) 
{
	string output;
	int count = 0;
	int match = 0;
	stack <char> stack1;
	stack <char> stack2;
	int size = input.length();
	for (int i = 0; i < size; i++)
	{
		stack1.push(input[i]);
	}
	while (count < size)
	{
		char x = stack1.top();
		 stack1.pop();
		 char y = stack1.top();
		 while ( !stack1.empty() )
		 {
			 if (x == y)
			 {
				 match++;
				 stack1.pop();
				 size--;
				 while (!stack1.empty())
				 {
					 y = stack1.top();
					 stack1.pop();
					 stack2.push(y);
				 }
				 break;
			 }
			 else
			 {
				 stack2.push(y);
				 stack1.pop();
				 if (!stack1.empty())
				 {
					 y = stack1.top();
				 }
			 }
			 
			  
		 }
		 if (match == 0)
		 {
			 output += x;
		 }
		
		 while (!stack2.empty())
		 {
			 char a = stack2.top();
			 stack2.pop();
			 stack1.push(a);
		 }
		 count++;
		
	}
	int l = output.length();
	for (int i = 0; i < l; i++)
	{
		stack2.push(output[i]);
	}
	output = '\0';
	while (!stack2.empty())
	{
		char val = stack2.top();
		stack2.pop();
		 output += val;
	}
	while (!stack1.empty())
	{
		stack1.pop();
	}

	return output;
	

}
int main() {
	cout << removePairs("assassin") << endl;
	
	cout << removePairs("an assassin sins") << endl;
//	cout << removePairs("pacific ocean") << endl;
	return 0;
}