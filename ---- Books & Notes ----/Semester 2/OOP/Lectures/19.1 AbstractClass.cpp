#include <iostream>
#include <string>
using namespace std;

//ABSTRACT class Shape
class shape {
	//coordinates of center common to all shapes
private:
	int x;
	int y;
public:
	shape(int x = 0, int y = 0) { this->x = x; this->y = y; }
	virtual void Draw() {
		cout << "Shape X= " << x << " Y= " << y << "\n";
	}// = 0;
	virtual void calculateArea() = 0; // pure virtual 
	virtual ~shape() { cout << "~Shape\n"; }  //make destructor virtual 
	operator float() { return 32.9f; }

	friend ostream& operator << (ostream& out, const shape& s);
	friend istream& operator >> (istream& in, shape& s);
};

ostream& operator<< (ostream& out, const shape& s)
{
	out << s.x;
	out << s.y << endl;
	return out;
}

istream& operator >> (istream& in, shape& s)
{
	in >> s.x;
	in >> s.y;
	return in;
}

class Circle : public shape {
	int radius;
public:
	Circle(int x = 0, int y = 0, int r = 0) :shape(x, y)
	{
		radius = r;
	}
	~Circle() { cout << "~Circle\n"; }
	//Implement all pure virtual funxtions to make it concrete class
	void Draw() {
		//__super::Draw(); 
		cout << "Circle: Radius= " << radius << endl;
		//shape::Draw();
	}
	friend ostream& operator<< (ostream& out, const  Circle& c);
	friend istream& operator >> (istream& in, Circle& c);
	void calculateArea() {
		cout << "Area of circle: " << 2 * 3.14 * radius * radius << endl;
	}
};
ostream& operator<< (ostream& out, const  Circle& c) {
	out << c.radius;
	//out << (shape)c;
	return out;
}

istream& operator >> (istream& in, Circle& c)
{
	in >> c.radius;
	//in >> (shape)c; //wrong
	return in;
}

class Rectangle : public shape {
	int length;
	int  width;
public:
	Rectangle(int x = 0, int y = 0, int l = 0, int w = 0) :shape(x, y) {
		length = l;
		width = w;
	}
	~Rectangle() { cout << "~Rectangle\n"; }
	void Draw() {
		shape::Draw();
		cout << "Rectangle: " << " Length= " << length << " Width= " << width << endl;
	}
	void calculateArea() {
		cout << "Area of Rectangle: " << length * width << endl;
	}
};

class Triangle : public shape {
	int base;
	int height;
public:
	Triangle(int x = 0, int y = 0, int b = 0, int h = 0) :shape(x, y) {
		base = b;
		height = h;
	}

	~Triangle() { cout << "~square\n"; }

	void Draw() {
		shape::Draw();
		cout << "Square: " << " Base= " << base << " Height= " << height << endl;
	}
	 /* void calculateArea(){
		 cout << "Area of Triangle: " << 0.5 * (base * height) << endl;
	 } */
};



int main() {
	//shape s(29, 99);
	////cout << s;
	//s.Draw();
	//s.calculateArea();
	////shape s; //check Error system will not allow to create objects of abstrat class
	//{ 
	// Circle c(2, 3, 4);
	////cin >> c;
	// Rectangle r(5, 6, 8, 9);
	// c.Draw();
	// r.Draw();
	// cout << c;
	//}
	cout << endl;
	int size = 4;
	shape** s = new shape * [size]; //Empty container for holding different shapes (pointer array)
	//s[0] = new shape; // not allowed due to abstract class
	s[0] = new Circle(2, 1, 9);
	s[1] = new Rectangle(2, 2, 3, 5);
	s[2] = new Circle(2, 6, 8);
	s[3] = new Triangle(2, 3, 5, 9); //check it As square did not implementd all pure virtual functions it became virtual too.

	for (int i = 0; i < size; i++)
	{
		s[i]->Draw();  			//polymorphism virtual function
		s[i]->calculateArea();  //polymorphism pure virtual function
		cout << endl;
	}

	for (int i = 0; i < size; i++)
		delete s[i]; //polymorphism on destructor call
	delete[] s;

	return 0;
}

