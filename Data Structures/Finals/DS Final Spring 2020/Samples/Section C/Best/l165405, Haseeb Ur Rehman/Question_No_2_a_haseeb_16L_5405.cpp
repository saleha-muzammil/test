//Haseeb
//16L-5405
// Question 2 part a 

#include <iostream>
#include <stack>
#include <string>

using namespace std;

void PrintStack(stack<char> s)
{
	if (s.empty())
		return;

	char x = s.top();
	s.pop();

	PrintStack(s);
	
	cout << x << " ";

	s.push(x);
}



string removePairs(string input)
{
	if (input.length() < 2)
		return input;

	stack <char> stack1;
	stack <char> stack2;
	//Write code here   

	int pushCount = 0;
	char ch;

	for (int i = 0; i < input.length(); i++)
	{
		stack1.push(input[i]);
	}

	//pop the top value in stack
	ch = stack1.top();
	stack1.pop();

	
	do
	{

		char temp = stack1.top();
		stack1.pop();

		cout <<"stack 1" << endl;
		PrintStack(stack1);
		cout << endl;
		cout << "stack 2" << endl;
		PrintStack(stack2);
		cout << endl;
		cout << "Ch : " << ch << endl;
		cout << "temp : " << temp << endl;



		//cout << "he " << ch << " PushCount " << pushCount << endl;

		if (temp == ch)
		{
			while (!stack2.empty() && pushCount != 0)
			{
				stack1.push(stack2.top());
				stack2.pop();

				pushCount--;
			}

			if (!stack1.empty())
			{
				ch = stack1.top();
				stack1.pop();

				//cout << "he " << ch << " PushCount " << pushCount << endl;

				if (stack1.empty())
					stack2.push(ch);
					continue;
			}
		}
		else
		{
			stack2.push(temp);

			pushCount++;
		}
		
		if (stack1.empty())
		{
			//cout << "he " << ch <<" PushCount " << pushCount<< endl;
			while (pushCount > 0)
			{
				stack1.push(stack2.top());

				stack2.pop();

				pushCount--;
			}

			if (ch != temp)
				stack2.push(ch);
			
			if (!stack1.empty())
			{
				ch = stack1.top();
				stack1.pop();
				
		
				if (stack1.empty())
					stack2.push(ch);
			}

		}


		/*stack2.push(ch);
		if (!stack1.empty())
		{
			ch = stack1.top();
			stack1.pop();
		}*/

	} while (!stack1.empty() || pushCount != 0);


	string s = "";

	while (!stack2.empty())
	{
		s = s + stack2.top();
		stack2.pop();
	}

	return s;
}

int main()
{
	cout << removePairs("haseeb ur rehman") << endl;
	//cout << removePairs("an assassin sins") << endl;
	//cout << removePairs("pacific ocean") << endl;

	system("pause");

	return 0;
}
