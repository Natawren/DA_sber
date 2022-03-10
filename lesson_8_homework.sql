--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select f.member_name, f.status, sum(p.unit_price*p.amount) as costs
from FamilyMembers f
join Payments p
on f.member_id = p.family_member
where  extract(year from p.date) = 2005
group by status, member_name

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name from Passenger
group by name
having count(name) > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as count
   from Student
 where first_name = 'Anna'
group by first_name

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(distinct classroom) as count from schedule s
where s.date ='2019.09.02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as count
   from Student
 where first_name = 'Anna'
group by first_name

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
SELECT floor(avg(TIMESTAMPDIFF(YEAR,  birthday, CURRENT_TIME))) as age
from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select gt.good_type_name,  
        sum(p.unit_price * p.amount) as costs
from
GoodTypes gt
left join Goods  g
on gt.good_type_id = g.type
left join Payments p
on p.good = g.good_id
where extract(year from p.date) = 2005
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select distinct TIMESTAMPDIFF(YEAR, max(birthday) over() , CURRENT_DATE) as year
from student



--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
select distinct TIMESTAMPDIFF(YEAR, min(s.birthday) over() , CURRENT_DATE) as max_year
from student s
join student_in_class sic
on s.id = sic.student
join Class c
on c.id = sic.class
where  c.name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
select f.status,
       f.member_name, 
        sum(p.unit_price * p.amount) as costs
from
GoodTypes gt
left join Goods  g
on gt.good_type_id = g.type
left join Payments p
on p.good = g.good_id
left join FamilyMembers f
on f.member_id = p.family_member
where gt.good_type_name = 'entertainment'
group by f.status, f.member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
delete from Company
where id in 
(with t as (select count(company) as count_trips, company from trip group by company),
    t1 as(select min(count_trips) from t)
select company
from t
where t.count_trips = (select * from t1))
 
--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
with t as (select classroom, count(*) as cnt from Schedule
            group by classroom),
     t1 as (select max(cnt) from t)
select classroom from t 
where cnt = (select * from t1)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select distinct t.last_name
from Schedule s
join subject su 
    on s.subject = su.id
join teacher t
    on s.teacher = t.id
where su.name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select * from 
(select concat(last_name,'.', left(first_name, 1),'.', left(middle_name,1),'.') as name from student) a
order by a.name

