#include <iostream>
#include <stack>
#include <string>
using namespace std;

string removePairs(string input)
{
	stack<char> stck; //1st stack
	int stacklength=input.length();
	int size=stacklength-1;
	for(int i = 0; i < input.length(); i++)
		stck.push(input.at(i));

	for(int k=0; k<size; k++){ //only 2 constanst used
	for(int i=k+1; i<size; i++)
	{
		if(stck[k]==stck[k+i])
		{
			stck[k]='/0';
			stck[k+i]='/0';
		}
		
	}}

	input = '/0';
	char g;//3rd constant
	while(!stck.empty())
		{
			g=stck.pop();
			if(g!='/0'){
			stck.push(g);
			input.push(stck.top());
			stck.pop();}
		}
}

int main()
{
	cout<<removePairs("assassin")<<endl;
	cout<<removePairs("an assassin sins")<<endl;
	cout<<removePairs("pacific ocean")<<endl;

system("pause");
return 0;
}