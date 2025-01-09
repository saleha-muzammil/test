Assume that we have the postfix expression in a variable postfixExpr.

stack operands;
while (postfixExpr.hasToken())
{
   token=postfixExpr.getNextToken();
	if (token is operand)
		operands.push(token);
	else{
		operand2=operands.pop();
		operand1=operands.pop();
	
		result=applyOperation(operand1, operands2, token);
		operands.push(result);
		
	}
}
cout<<operands.pop(); //final result
