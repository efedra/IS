#include <iostream>
#include <queue>
#include <set>
#include <ctime>
#include <stack>

using namespace std;

const bool inside[7][7] = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 0, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 0, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 0, 0} };

class State
{
public:
	bool val[7][7];
	const State* prev;
	int dep;
	int count;

	State(bool v[7][7], const State* p, int d, int c)
	{
		prev = p;
		dep = d;
		count = c;
		for (int i = 0; i < 7; i++)
			for (int j = 0; j < 7; j++)
				val[i][j] = v[i][j];
	}

	friend bool operator== (const State& s1, const State& s2);
	friend bool operator< (const State& s1, const State& s2);
};
bool operator< (const State& s1, const State& s2)
{
	for (int i = 0; i < 7; i++)
		for (int j = 0; j < 7; j++)
		{
			if (s1.val[i][j] < s2.val[i][j]) return true;
			else if (s1.val[i][j] > s2.val[i][j]) return false;
		}
	return false;
}
bool operator== (const State& s1, const State& s2)
{
	for (int i = 0; i < 7; i++)
		for (int j = 0; j < 7; j++)
		{
			if (s1.val[i][j] < s2.val[i][j]) return false;
			else if (s1.val[i][j] > s2.val[i][j]) return false;
		}
	return true;
}


// Кол-во соседей
int Heuristic(const bool field[7][7])
{
	int ans = 0;
	for (int i = 0; i < 7; i++)
	{
		for (int j = 0; j < 7; j++)
		{
			if (inside[i][j] && field[i][j])
			{
				if (i > 0) // up neighboor
				{
					ans += field[i - 1][j];
				}
				
				if (j < 6) // right neighboor
				{
					ans += field[i][j + 1];
				}
				
				if (i < 6) // down neighboor
				{
					ans += field[i + 1][j];
				}
				
				if (j > 0) // left neighboor
				{
					ans += field[i][j - 1];
				}
				
			}
		}
	}
	return ans;
}

int CountDots(bool field[7][7])
{
	int ans = 0;
	for (int i = 0; i < 7; i++)
		for (int j = 0; j < 7; j++)
			ans += (inside[i][j] && field[i][j]);
	return ans;
}

queue<State> MakeMoves(const State* s)
{
	queue<State> q;
	bool field[7][7];
	for (int i = 0; i < 7; i++)
		for (int j = 0; j < 7; j++)
			field[i][j] = s->val[i][j];

	for (int i = 0; i < 7; i++)
	{
		for (int j = 0; j < 7; j++)
		{
			if (inside[i][j] && field[i][j])
			{
				if (i > 1) // up
				{
					if (field[i - 1][j] && !field[i - 2][j] && inside[i - 1][j] && inside[i - 2][j])
					{
						field[i][j] = 0;
						field[i - 1][j] = 0;
						field[i - 2][j] = 1;
						q.push(State(field, s, s->dep + 1, s->count - 1));
						field[i][j] = 1;
						field[i - 1][j] = 1;
						field[i - 2][j] = 0;
					}
				}
			
				if (j < 5) // right
				{
					if (field[i][j + 1] && !field[i][j + 2] && inside[i][j + 1] && inside[i][j + 2])
					{
						field[i][j] = 0;
						field[i][j + 1] = 0;
						field[i][j + 2] = 1;
						q.push(State(field, s, s->dep + 1, s->count - 1));
						field[i][j] = 1;
						field[i][j + 1] = 1;
						field[i][j + 2] = 0;
					}
				}
				
				if (i < 5) // down
				{
					if (field[i + 1][j] && !field[i + 2][j] && inside[i + 1][j] && inside[i + 2][j])
					{
						field[i][j] = 0;
						field[i + 1][j] = 0;
						field[i + 2][j] = 1;
						q.push(State(field, s, s->dep + 1, s->count - 1));
						field[i][j] = 1;
						field[i + 1][j] = 1;
						field[i + 2][j] = 0;
					}
				}
				
				if (j > 1) // left
				{
					if (field[i][j - 1] && !field[i][j - 2] && inside[i][j - 1] && inside[i][j - 2])
					{
						field[i][j] = 0;
						field[i][j - 1] = 0;
						field[i][j - 2] = 1;
						q.push(State(field, s, s->dep + 1, s->count - 1));
						field[i][j] = 1;
						field[i][j - 1] = 1;
						field[i][j - 2] = 0;
					}
				}
			
			}
		}
	}
	return q;
}

void Print(bool field[7][7])
{
	for (int i = 0; i < 7; i++)
	{
		for (int j = 0; j < 7; j++)
			cout << field[i][j] << ", ";
		cout << endl;
	}

}
void Print(const bool field[7][7])
{
	for (int i = 0; i < 7; i++)
	{
		for (int j = 0; j < 7; j++)
			cout << field[i][j] << ", ";
		cout << endl;
	}

}

stack<State>Solve(bool field[7][7])
{
	stack<State> ams;
	auto cmp = [](const State* l, const State* r)
	{
		return (l->dep + Heuristic(l->val)) > (r->dep + Heuristic(r->val));
	};
	auto que = priority_queue<const State*, vector<const State*>, decltype(cmp)>(cmp);
	set<State> vals;
	int startCount = CountDots(field);
	if (startCount < 2)
	{
		cout << "Already there" << endl;
		return ams;
	}
	State s = State(field, nullptr, 0, startCount);
	const State* spointer = &(*(vals.insert(s).first));
	que.push(spointer);
	while (!que.empty())
	{
		const State* curS = que.top();
		que.pop();
		
		cout << "!!! " << curS->count << endl;
		if (curS->count < 2)
		{
			
			ams.push(*curS);
			while (curS->prev!=nullptr)
			{
				curS = curS->prev;
				ams.push(*curS);
			}
			return ams;
		}
		queue<State> q = MakeMoves(curS);
		while (!q.empty())
		{
			State curSS = q.front();
			q.pop();
			

			pair<set<State>::iterator, bool> t = vals.insert(curSS);
			if (t.second == true)
				que.push(&*t.first);
		}
	}
	cout << "No Solution :(" << endl;
	return ams;

}



	

		

			

				

				
int main()
{
	// i-строка j-столб
	bool field[7][7] = {
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 0, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 0} };           //Done in: 136.174 seconds

	/*bool field[7][7] = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 0, 0, 0, 0, 0},
	{0, 0, 1, 1, 0, 0, 0},
	{0, 0, 0, 1, 1, 0, 0} };*/                 //Done in: 0.001 seconds 4 шага

	/*bool field[7][7] = {
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0},
		{0, 0, 1, 1, 0, 0, 0},
		{0, 0, 1, 1, 0, 0, 0},
		{0, 0, 1, 1, 1, 0, 0} }; */             //Done in: 0.002 seconds 7 шагов

	/*bool field[7][7] = {
			{0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 1, 0, 0},
			{0, 0, 1, 0, 0, 0, 0},
			{0, 0, 1, 0, 1, 1, 0},
			{0, 0, 1, 1, 1, 0, 0},
			{0, 0, 1, 1, 1, 0, 0} };*/     //  Done in: 0.05 seconds 10 шагов

/*	bool field[7][7] = {
				{0, 0, 0, 0, 1, 0, 0},
				{0, 0, 0, 0, 0, 0, 0},
				{0, 0, 0, 1, 1, 0, 0},
				{0, 0, 1, 0, 1, 0, 1},
				{0, 0, 1, 0, 1, 1, 1},
				{0, 0, 1, 1, 1, 0, 0},
				{0, 0, 1, 1, 1, 0, 0} }; */        // Done in: 0.14 seconds 15 шагов


/*	bool field[7][7] = {
					{0, 0, 0, 0, 1, 0, 0},
					{0, 0, 0, 0, 1, 0, 0},
					{0, 0, 0, 1, 1, 1, 1},
					{0, 0, 1, 0, 0, 0, 1},
					{0, 0, 1, 0, 1, 1, 1},
					{0, 0, 1, 1, 1, 0, 0},
					{0, 0, 1, 1, 1, 0, 0} }; */   // Done in: 0.157 seconds 17 шагов


	/*bool field[7][7] = {
						{0, 0, 1, 1, 1, 0, 0},
						{0, 0, 1, 1, 1, 0, 0},
						{1, 1, 1, 0, 1, 1, 1},
						{1, 1, 1, 0, 1, 1, 1},
						{1, 1, 1, 1, 1, 1, 1},
						{0, 0, 1, 1, 1, 0, 0},
						{0, 0, 1, 1, 1, 0, 0} };*/  // Done in: 9.813 seconds 30 шагов

	clock_t t = clock();
	std::stack<State> ams=Solve(field);
	t = clock() - t;
	while (!ams.empty())
	{
		State s = ams.top();
		ams.pop();
		Print(s.val);
		cout << endl;
	}
	cout << "Done in: " << ((float)t) / CLOCKS_PER_SEC << " seconds" << endl;

}