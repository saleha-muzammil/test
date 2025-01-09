infixExp="2+3*4";

infixExp.getNextToken();
stack operators;


short hasPrec(char op1, char op2)
{
	if (op1==op2)
		return 0;

    if (op1=='/' || op1=='*')
    {
        if (op2=='+' || op2=='-')
            return 1;

        if (op2=='^')
        	return -1;
			
		if (op2=='*' || op2=='/')
			return 0;
			
    }

    else if (op1=='+' || op1=='-')
    {	
    	if (op2=='/' || op2=='*' || op2=='^')
    		return -1;
			
		if (op2=='-' || op2=='+')
			return 0;
    }

    else if (op1=='^')
    {
    	if (op2=='*' || op2=='/' || op2=='+' || op2=='-')
    		return 1;

    }

}

bool associativity(char op)
{
	if (op=='*' || op=='/' || op=='+' || op=='-')
	return 0; //left to right

	else if (op=='^')
	return 1; //right to left
}

int main()
{
	infixExpr=getExpr();
	stack operators;
	postFixExpr;

	while (infixExpr.hasToken())
	{
		token= infixExpr.getNextToken();

		if (token is operand)
			postFixExpr.append(token);

		else //token is an operator
		{	
			if (token=='(' || stack.top()=='(')
			{
				stack.push(token);
				continue;
			}
			else if (token==')')
			{	
				if (stack.top()=='(')
				{
					stack.pop();
					continue;
				}
				
				postFixExpr.append(stack.pop())
				infixExpr.insertAtStart(token);
				continue;
			}

			if (stack.isEmpty())
			{
				stack.push(token)
				continue;
			}
			prec=hasPrec(token, stack.top())
			if (prec==1)
				stack.push(token);

			else if (prec==-1)
			{
				postFixExpr.append( stack.pop());
				infixExpr.insertAtStart(token);

			}

			else 
			{  
			    assoc=associativity(token);
			    if (assoc==0)
			    {
			    	postFixExpr.append( stack.pop());
					infixExpr.insertAtStart(token);
			    }
			    else
			    {
			    	stack.push(token);
			    }

			}

		}
	}//end of while loop.

	while (!stack.isEmpty())
	{
		postFixExpr.append( stack.pop());
	}
}