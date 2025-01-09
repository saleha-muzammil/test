#include<iostream>
using namespace std;


class divByZero:public exception{
public:
	divByZero(char * m) :exception(m){}
	const char * what() const override{
		cout<< "I am in div By Zero Class" <<endl;
		return exception::what();

	}
};

class arrayIndexoutofBound : public exception{
public:
	arrayIndexoutofBound(char  * msg) :exception(msg){}
	const char virtual * what() const override {
		cout << "Array index out of Bound" << endl;
		return exception::what();
	}
};

void fun(int x, int y)
{
	if (y == 0)
		throw divByZero("div");
	cout << x / y;

}

void badAlloc(){
	int * arr[5];
	try{
		for (int i = 0; i < 5; i++)
			arr[i] = new int[100000000];
		cout << "done";
	}
	catch (bad_alloc b){
		cout << b.what();
	}
	catch (runtime_error r){
		cout << r.what();
	}
}

void main() {

	int arr[5] = { 1, 2, 3, 4, 5 };
	try{
		int i = 0;
		cin >> i;
		if (i >= 5 || i < 0) 
			throw runtime_error("Boundry");
		arr[i] = 100;
		cout << arr[i];
	}
	catch (exception & a){
		//arrayIndexoutofBound& a2 = dynamic_cast<arrayIndexoutofBound&>(a);
		cout<< a.what()<< endl;
	}


//	cout << "Add Execution of code after execption Handling in catch" << endl;

	/*int x = 0, y = 0;
	cin >> x >> y;
	
			try{
				
				fun(x, y);
				/*if (y == 0)
					throw exception (0);
				if (y < 0)
					throw exception ("Negative");
				*/
			//}
			/*catch(divByZero e){
				cout<< e.what();
			}
			catch (exception e){
				cout << e.what() <<endl;
				//throw ch;
			}*/
	

	cout << endl;

}


