#include <iostream>
#include "Header.h"

int main()
{

	
	Current_state Begin = { 100000000,NULL,NULL}; // начальное состояние 
	Current_state End{ 1,NULL,NULL }; // конечное состояние 

	std::queue <Current_state> q;
	q.push(Begin); // положили в очередь начало 

	std::set <Current_state> container;

	std::vector<Current_state> result; //для чисел без повторений

	unsigned int start_time = clock(); //начало замера

	while (!q.empty()) {
		
		Current_state pull = q.front();
		q.pop();

		
		if ( pull.state== End.state) 
		{
			result.push_back(pull);
			break;
			
		}
		else {
			
			bool check = container.find(pull) != container.end();// проверка есть ли в set такое число 
			if(!check)
			{ 
				if (pull.state % 2 == 0)
				{

					container.insert(pull);
					q.push({ pull.state - 3,pull.state,1 });
					q.push({ pull.state / 2 ,pull.state,2 });
					//q.push({ pull.state - 2,pull.state,3 }); 
				}
				else
				{
					container.insert(pull);
					q.push({ pull.state - 3,pull.state,1 }); 
				}
				result.push_back(pull);
			}
		}
	}


	std::vector<Current_state> answer; 
	answer.push_back(result.back());
	int parrent = answer[0].parrent;

	for (int i = result.size()-2; i >=0; i--) //возврашемся обратно 
	{
		if (parrent == result[i].state)
		{
			answer.push_back (result[i]);
			parrent = result[i].parrent;
		}
		
	}
	
	//вывод на экран ( массив в обратно порядке=((()

	for (int i = answer.size()-1; i>=0; i--)
	{
		std::cout << answer[i].state << " ";
	}

	std::cout << std::endl;
	std::cout << "Time: " << clock() / 1000.0 << std::endl;
}

// с 2мя операциями прямой поиск 
//1 4 8 11 22 44 47 94 188 376 379 758 761 1522 1525 3050 6100 6103 12206 24412 48824 48827 97654 195308 195311 390622 390625 781250 1562500 3125000 6250000 12500000 25000000 50000000 100000000
//Time: 14.931

// с 3мя операциями прямой поиск
//1 4 7 10 20 23 46 92 95 190 380 760 763 1526 3052 6104 12208 24416 24414 48828 97656 195312 390624 390627 390625 781250 1562500 3125000 6250000 12500000 25000000 50000000 100000000
//Time: 40.212

//с 2мя оперцаиями обратный поиск
//100000000 50000000 25000000 12500000 6250000 3125000 1562500 781250 390625 390622 195311 195308 97654 48827 48824 24412 12206 6103 6100 3050 1525 1522 761 758 379 376 188 94 47 44 22 11 8 4 1
//Time: 0.069


