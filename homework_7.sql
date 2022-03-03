--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко
import sqlite3
import pandas as pd
import random
conn = sqlite3.connect('task1_7')  
c = conn.cursor()
df = pd.DataFrame({'first_col':[random.randint(1,1000) for i in range(1000)],
                  'second_col': [random.randint(1,1000) for i in range(1000)],
                  'third_col': [random.randint(1,1000)for i in range(1000)]})
request = "CREATE TABLE table1(first_col int, second_col int, third_col int)"
c.execute(request)
df.to_sql(name='table1',if_exists='append',index=False, con=conn)


--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from person
group by email
having count(email) > 1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
select e1.name
from employee e1
left join employee e2
on e1.managerId = e2.id
where e1.salary > e2.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select score,
       dense_rank() over( order by score desc) as rank
    from scores

    
--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstName, lastName, city, state
from person p
left join address a
on p.personId = a.personId
