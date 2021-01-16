#pragma once
#ifndef HEADER
#define HEADER
#include <set>
#include <queue>
#include <vector>
#include <ctime>

struct Current_state{

	int state;
	int parrent;
	int operation; //1-- прибавить 3, 2--умножить на 2 , 3-- отнять 2




	friend bool operator< (const Current_state& c1, const Current_state& c2)
	{
		return c1.state < c2.state;
	}

	friend bool operator==(const Current_state& c1, const Current_state& c2)
	{
		return c1.state == c2.state && c1.parrent == c2.parrent&& c1.operation == c2.operation;
	}

	friend bool operator!=(const Current_state& c1, const Current_state& c2)
	{
		return !(c1==c2);
	}
};




#endif