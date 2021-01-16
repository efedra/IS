#pragma once
#include <iostream>
#include <vector>
#include <string>
#include <list>
#include <unordered_set>
#include <algorithm>
#include <fstream>
#include <climits>
#include <cmath>
#include <unordered_set>

enum class route { Up, Down, Left, Right, Space };

std::vector<bool> board(64, false);

int checker_1 = -1;
int checker_2 = -1;

int position_1;
int position_2;

class Desk
{
public:
	std::vector<int> position;
	int player_number;

	Desk(const std::string& s, int player)
	{
		this->player_number = player;

		for (int i = 0; i < 12; ++i)
		{
			int row = s[i * 2 + 1] - '1';
			int col = s[i * 2] - '1';
			position.push_back(col + row * 8);
			board[col + row * 8] = true;
		}
	}

	Desk(const std::vector<int>& positions, int player)
	{
		this->position = positions;
		this->player_number = player;
	}

	Desk* Step(int num_check, int new_positions)
	{
		std::vector<int> v = position;

		board[v[num_check]] = false;
		board[new_positions] = true;

		v[num_check] = new_positions;

		return new Desk(v, player_number);
	}

	std::vector<int> EverythingJump(int current_pos)
	{
		std::vector<int> answer;
		std::unordered_set<int> set_steps;

		set_steps.insert(current_pos);

		if (Moves(route::Right, current_pos))
		{
			answer.push_back(current_pos + 1);
			set_steps.insert(current_pos + 1);
		}
		else if (current_pos % 8 != 7)
		{
			int next_pos = current_pos + 1;

			if (Moves(route::Right, next_pos) && set_steps.find(next_pos) == set_steps.end())
			{
				answer.push_back(next_pos + 1);
				set_steps.insert(next_pos + 1);
				Jump(next_pos + 1, set_steps, answer);
			}
		}

		if (Moves(route::Left, current_pos))
		{
			answer.push_back(current_pos - 1);
			set_steps.insert(current_pos - 1);
		}
		else if (current_pos % 8 != 0)
		{
			int next_position = current_pos - 1;

			if (Moves(route::Left, next_position) && set_steps.find(next_position) == set_steps.end())
			{
				answer.push_back(next_position - 1);
				set_steps.insert(next_position - 1);
				Jump(next_position - 1, set_steps, answer);
			}
		}

		if (Moves(route::Up, current_pos))
		{
			answer.push_back(current_pos + 8);
			set_steps.insert(current_pos + 8);
		}
		else	 if (current_pos / 8 != 7)
		{
			int next_position = current_pos + 8;

			if (Moves(route::Up, next_position) && set_steps.find(next_position) == set_steps.end())
			{
				Jump(next_position + 8, set_steps, answer);
				answer.push_back(next_position + 8);
				set_steps.insert(next_position + 8);
			}
		}
		if (Moves(route::Down, current_pos))
		{
			answer.push_back(current_pos - 8);
			set_steps.insert(current_pos - 8);
		}
		else if (current_pos / 8 != 0)
		{
			int next_pos = current_pos - 8;

			if (Moves(route::Down, next_pos) && set_steps.find(next_pos) == set_steps.end())
			{
				answer.push_back(next_pos - 8);
				set_steps.insert(next_pos - 8);
				Jump(next_pos - 8, set_steps, answer);
			}
		}

		return answer;
	}


	bool Is_Final()
	{
		if (player_number == 1)
		{
			for (int i = 0; i < 12; ++i)
			{
				if (position[i] % 8 > 3 || position[i] / 8 > 2)
					return false;
			}
		}
		else
		{
			for (int i = 0; i < 12; ++i)
			{
				if (position[i] % 8 < 4 || position[i] / 8 < 5)
					return false;
			}
		}

		return true;
	}

	friend bool operator==(const Desk& c1, const Desk& c2)
	{
		return c1.position == c2.position;
	}

	Desk& operator=(const Desk& m)
	{
		if (&m == this)
		{
			return *this;
		}

		this->position.resize(12);

		for (int i = 0; i < 12; i++)
		{
			this->position[i] = m.position[i];
		}

		this->player_number = m.player_number;

		return *this;
	}

	Desk* operator=(const Desk* m)
	{
		if (m == this)
		{
			return this;
		}

		*this = new Desk(m->position, m->player_number);

		return this;
	}

private:

	bool Moves(route d, int current_pos)
	{
		return d == route::Right && current_pos % 8 != 7 && !board[current_pos + 1] || d == route::Left && current_pos % 8 != 0 && !board[current_pos - 1] || d == route::Down && current_pos / 8 != 0 && !board[current_pos - 8] || d == route::Up && current_pos / 8 != 7 && !board[current_pos + 8];
	}

	void Jump(int current_pos, std::unordered_set<int>& steps, std::vector<int>& new_steps) 
	{
		if (current_pos % 8 != 7 && !Moves(route::Right, current_pos))
		{
			int next_pos = current_pos + 2;
			if (Moves(route::Right, current_pos + 1))
			{
				if (steps.insert(next_pos).second)
				{
					new_steps.push_back(next_pos);
					Jump(next_pos, steps, new_steps);
				}
			}
		}

		if (current_pos % 8 != 0 && !Moves(route::Left, current_pos))
		{
			int next_pos = current_pos - 2;
			if (Moves(route::Left, current_pos - 1))
			{
				if (steps.insert(next_pos).second)
				{
					new_steps.push_back(next_pos);
					Jump(next_pos, steps, new_steps);
				}
			}
		}

		if (current_pos / 8 != 7 && !Moves(route::Up, current_pos))
		{
			int next_pos = current_pos + 16;
			if (Moves(route::Up, current_pos + 8))
			{
				if (steps.insert(next_pos).second)
				{
					new_steps.push_back(next_pos);
					Jump(next_pos, steps, new_steps);
				}
			}
		}

		if (current_pos / 8 != 0 && !Moves(route::Down, current_pos))
		{
			int next_pos = current_pos - 16;
			if (Moves(route::Down, current_pos - 8))
			{
				if (steps.insert(next_pos).second)
				{
					new_steps.push_back(next_pos);
					Jump(next_pos, steps, new_steps);
				}
			}
		}
	}
};

Desk* second_player;
Desk* first_player;

class Jumps
{
public:

	Jumps()
	{

	}

	std::pair<char, std::string> Get_Step()
	{
		std::cout << "Choose checker for step" << std::endl;

		char c;

		std::cin >> c;

		

		std::cout << std::endl << "Enter position's checker: " << std::endl;
		std::string s;
		std::cin >> s;

		return { c, s };
	}

	int Find(char c)
	{
		int n = 0;

		if (isdigit(c))
		{
			n = c - '1';
		}
		else
		{
			n = c - 'a' + 9;
		}

		return n;
	}

	std::pair<int, int> convert_step(std::pair<char, std::string> step)
	{
		char c = step.first;
		std::string s = step.second;

		int n = 0;
		if (isdigit(c))
		{
			n = c - '1';
		}
		else
		{
			n = c - 'a' + 9;
		}

		int ind = (s[1] - '1') * 8 + (s[0] - '1');

		return { n, ind };
	}

	std::string Convert_Step(int position)
	{
		std::string full_position;
		full_position.resize(2);
		full_position[0] = ('1' + position / 8);
		full_position[1] = ('1' + position / 8);

		return  full_position;
	}

	bool Is_Correct_Step(std::pair<char, std::string> step)
	{
		if (step.second.length() != 2)
			return false;

		char checker = step.first;
		char pos_digit_1 = step.second[0];
		char pos_digit_2 = step.second[1];

		if (!isdigit(checker) && checker != 'a' && checker != 'b' && checker != 'c')
		{
			return false;
		}

		if (!(pos_digit_1 >= '1' && pos_digit_2 <= '9'))
		{
			return false;
		}

		if (!(pos_digit_2 >= '1' && pos_digit_2 <= '9'))
		{
			return false;
		}

		std::pair<int, int> p = convert_step(step);
		std::vector<int> l = second_player->EverythingJump(second_player->position[p.first]);

		auto it = find(l.begin(), l.end(), p.second);

		return it != l.end();
	}

	std::pair<char, std::string> Get_Correct_Step()
	{
		std::pair<char, std::string> p = Get_Step();
		

		while (!Is_Correct_Step(p))
		{
			std::cout << "Incorrect checker or step" << std::endl;
			p = Get_Step();
		}
		return p;
	}

	void Player_Step(char c, const std::string& s)
	{
		std::pair<int, int> p = convert_step({ c, s });
		checker_2 = p.first;
		position_2 = second_player->position[checker_2];
		second_player = second_player->Step(p.first, p.second);
	}

	~Jumps()
	{

	}
};

class Draw
{
	std::vector<std::string> board_lines;

public:

	Draw(int nplayer)
	{
		board_lines.resize(11);

		board_lines[1] = "  1 2 3 4 5 6 7 8 ";

		for (int i = 0; i < 8; ++i)
		{
			board_lines[i + 2] = std::to_string(i + 1) + "|_|_|_|_|_|_|_|_|";
		}

		if (nplayer == 1)
		{

			first_player = new Desk("586878885767778756667686", 1);
			second_player = new Desk("112131411222324213233343", 2);
		}
		else
		{

			first_player = new Desk("112131411222324213233343", 2);
			second_player = new Desk("586878885767778756667686", 1);
		}
	}

	void Сlear()
	{
		for (int i = 0; i < 8; ++i)
		{
			board_lines[i + 2] = std::to_string(i + 1) + "|_|_|_|_|_|_|_|_|";
		}
	}

	void Print_Position()
	{
		Сlear();
		for (int i = 0; i < 12; ++i)
		{
			int pos1 = second_player->position[i];
			int pos2 = first_player->position[i];

			board_lines[2 + pos2 / 8][(1 + pos2 % 8) * 2] = '*';

			board_lines[2 + pos1 / 8][(1 + pos1 % 8) * 2] = i > 8 ? (char)('a' + i - 9) : (char)('1' + i);
		}
	}

	void print()
	{
		Print_Position();
		for (int i = 0; i < 10; ++i)
		{
			std::cout << board_lines[i] << std::endl;
		}
	}

	~Draw()
	{
	}
};

class Game
{
	std::vector<int> checkers = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };

	std::pair<int, int> answer;

	Desk* me;
	Desk* other;

	int player_number;

	const int depth = 3;

public:
	Game()
	{
		std::cout << "Choose a side 1 or 2 :";

		std::cin >> player_number;

		if (player_number != 1 && player_number != 2)
		{
			player_number = 2;
		}

		Draw b(player_number);
		Jumps s;

		b.print();

		if (player_number == 1)
			while (!first_player->Is_Final() && !second_player->Is_Final())
			{
				std::pair<char, std::string> p = s.Get_Correct_Step();
			
					s.Player_Step(p.first, p.second);
					b.print();

					Start();
					std::cout << std::endl << "Steps's AI : ";
					first_player = first_player->Step(answer.first, answer.second);
					b.print();
				

			}
		else
		{
			Start();
			first_player = first_player->Step(answer.first, answer.second);
			b.print();

			while (!first_player->Is_Final() && !second_player->Is_Final())
			{
				std::pair<char, std::string> p = s.Get_Correct_Step();
				
					s.Player_Step(p.first, p.second);
					b.print();

					Start();
					first_player = first_player->Step(answer.first, answer.second);
					std::cout << s.Convert_Step(answer.second) << std::endl;
					b.print();
				
			}
		}
	}

	void Step(std::vector<bool>& board, Desk* cur, int num_check, int new_positions)
	{
		board[cur->position[num_check]] = false;
		board[new_positions] = true;
		cur->position[num_check] = new_positions;
	}

	int Manhatan_Distance(int current, int goal)
	{
		return abs(goal - current) / 8 + abs(goal - current) % 8;
	}

	int Heuristic(const std::vector<bool>& board, Desk* player, int nplayer)
	{
		int costs = 1;

		for (int i = 0; i < 12; ++i)
		{
			int h = 0;
			h = Manhatan_Distance(player->position[i], nplayer == 1 ? 0 : 63);

			costs += h;
		}
		return costs;
	}

	// alpha - значение выигрыша
	int RecursiveAlphaBeta(bool II, std::vector<bool>& cboard, Desk* player1, Desk* player2, int depth, int alpha, int beta)
	{
		if (II)
		{
			if (depth == 0)
			{
				return Heuristic(cboard, player1, player1->player_number);
			}

			std::vector<int> steps;
			int score;

			for (int x : checkers)
			{
				std::vector<bool> tboard = cboard;
				steps = player1->EverythingJump(player1->position[x]);

				for (int stp : steps)
				{

					Desk* st1 = new Desk(player1->position, player1->player_number);


					Desk* st2 = new Desk(player2->position, player2->player_number);

					

					Step(cboard, st1, x, stp);

					score = RecursiveAlphaBeta(false, cboard, st1, st2, depth - 1, alpha, beta);

					cboard = tboard;

					if (score >= beta)
					{
						delete st1;
						delete st2;

						return beta;
					}
					if (score > alpha)
					{
						alpha = score;
					}

					delete st1;
					delete st2;
				}
			}

			return alpha;
		}
		else
		{
			if (depth == 0)
			{
				return  -Heuristic(cboard, player2, player2->player_number);
			}

			std::vector<int> steps;
			int score;


			for (int x : checkers)
			{
				std::vector<bool> tboard = cboard;
				steps = player2->EverythingJump(player2->position[x]);

				for (int stp : steps)
				{

					Desk* st1 = new Desk(player1->position, player1->player_number);
					Desk* st2 = new Desk(player2->position, player2->player_number);



					Step(cboard, st2, x, stp);

					score = RecursiveAlphaBeta(true, cboard, st1, st2, depth - 1, alpha, beta);

					cboard = tboard;

					if (score <= alpha)
					{
						delete st1;
						delete st2;
						return alpha;

					}
					if (score < beta)
					{
						beta = score;
					}

					delete st1;
					delete st2;
				}
			}
			return beta;
		}
	}

	std::pair<int, int> Alpha_Beta(std::vector<bool>& cboard, Desk* player1, Desk* player2, int depth, int alpha, int beta)
	{
		std::pair<int, int> ans = { -1, -1 };
		int min = std::numeric_limits<int>::max();

		std::vector<int> steps;
		for (int x : checkers)
		{
			std::vector<bool> tboard = cboard;
			steps = player1->EverythingJump(player1->position[x]);

			for (int stp : steps)
			{
				Step(cboard, player1, x, stp);

				int res = RecursiveAlphaBeta(false, cboard, player1, player2, depth, alpha, beta);
				cboard = tboard;

				if (res < min)
				{
					min = res;
					ans = { x, stp };

				}
			}
		}

		return ans;
	}

	void Start()
	{
		me = new Desk(*first_player);

		other = new Desk(*second_player);

		answer = Alpha_Beta
		(board, me, other, depth, std::numeric_limits<int>::min(), std::numeric_limits<int>::max());

		checker_1 = answer.first;

		position_1 = first_player->position[checker_1];
	}

	~Game()
	{

	}

private:

};
