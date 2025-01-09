#include<iostream>
using namespace std;

class A{
	int a;
protected:
//Added to make non member operator << function virtual 
	virtual ostream& print(ostream & out) const
	{
		out << "From A: print(ostream& out)" << a << endl;
		return out;
	}

public:
	A() :a(0) {
		cout << "A()" << endl;
	}
	A(int a) :a(a){
		cout << "A(int a)" << endl;
	}
	A(const A & obj){
		cout << "A (const A&)" << endl;
		a = obj.a;
	}
	virtual ~A(){
		cout << "Dest of A()" << endl;
	}
	virtual void print() { cout << "a=" << a << endl; }
	void seta(int a){
		this->a = a;
		cout << "seta(int a)" << endl;
	}
	
	friend ostream &  operator << (ostream &out, A & obj);

protected:
	virtual void prot_func_A(){
		cout << "prot_func_A()from A" << endl;
	}
};

ostream &  operator << (ostream & out, A & obj){
	//out << "From A: " << obj.a << endl;
	out << "From A: "<< endl << endl;
	obj.print(out);
	return out;
}

class B : public A{
	int b;

protected:
//Added to make non member operator << function virtual 
	virtual ostream& print(ostream& out) const
	{
		A::print(out);
		out << "From B: print(ostream& out)" << b << endl;
		return out;
	}
public:
	B() :A(0), b(0) {
		cout << "B()";
	}
	B(int b, int a = 0) :A(a) {
		cout << "B(intb, inta=0)" << endl;
		this->b = b;
		//seta(a);
	}
	B(const B & obj):A(obj){
		cout << "B (const B&)" << endl;
		b = obj.b;
	}
	~B() {
		cout << "~B()" << endl;
	}
	void print() {
		cout << "b=" << b << endl;
		A::print();
		//__super::print();
	}
	void prot_func_A(){
		cout << "prot_func_A() fromB" << endl;
	}
	void prot_func_A(int b){
		cout << "prot_func_A(int b) fromB  " << b<< endl;
	}
	friend ostream &  operator << (ostream &out, B & obj);

};
//Non member function polymorphic behavior
ostream & operator << (ostream  &out, B & obj){
	out << "From B: " << endl << endl;
	obj.print(out);
	
	//out << "From B: " << obj.b <<endl;
	//A::operator<<(out, obj);
	//__super::print();
 
	//out << static_cast<A>(obj) << endl;
	//Explicit cast create new object
	//A a(obj); 
	//out << a; 
	//Slicing + copy constructor called for Base class A.
	return out;
}


void main() {
	A a(4);
	cout << a;

	B b(20, 98);
	cout << b;
	
	a = b;
	cout << a;

	A* ptr = new A(5);
	cout << *ptr;
	delete ptr;

	ptr = new B(3, 9);
	cout << *ptr;
	delete ptr;

	////B b(20, 98);
	////A a(4);
	//A * ptr;// = new A(5);
	////ptr->print();
	////delete ptr;

	//ptr = new B(50, 90);
	//ptr->print();
	//delete ptr;


	cout << "End" << endl;
}


