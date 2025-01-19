

#include <iostream>
#include <stack>
#include <string>
using namespace std;
string removePairs(string temp) 
{
	
	stack<char> s;
	stack <char> result;
	int ind1, ind2;
	int start = 0;

	for (int i = 0; i < temp.length(); i++)
	{
		result.push(temp[i]);
	}

	for (int i = temp.size() - 1; i >= 0; i--)
	{
		for (int i = 0; i < temp.length(); i++)
		{
			s.push(temp[i]);
		}

		ind1 = i;
		char checkThis = result.top();
		int count = 0;
		result.pop();

		for (int j = i; !s.empty();)
		{
			if (j != 0)
				j--;
			if (checkThis == s.top())
			{
				count++;
				ind2 = j;
			}
			s.pop();
		}
		if (count == 2)
		{
			temp[ind1] = '0';
			temp[ind2] = '0';
		}
	}

	for (int i = 0; i < temp.length(); i++)
	{
		if (temp[i] != '0')
		{
			s.push(temp[i]);
			cout << temp[i] << " ";
		}
	}
}
int main()
{
	cout << removePairs("assassin") << endl;
	cout << removePairs("an assassin sins") << endl;
	cout << removePairs("pacific ocean") << endl;
	return 0;
}