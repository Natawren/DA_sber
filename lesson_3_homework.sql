--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select c.class, count(o.result)
	from classes c
left join ships s 
	on s.class = c.class
left join outcomes o 
	on s.name = o.ship
where o.result = 'sunk' or o.result is NULL
group by c.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

with t1 as (select class, launched from ships where class = name),
	 t2 as (select s.class, min(s.launched) 
	 		  from ships s, t1 
	 		where s.class not in (select class from t1)
	 		group by s.class)
select c.class, t3.launched from classes c
left join (select * from t1 
			union 
		   select * from t2) t3
	on t3.class = c.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with t as (select s.class
				from ships s 
			group by s.class
			having count(s.name) >= 3)
select c.class, count(o.result) as sunk_number
	from classes c
left join ships s 
	on s.class = c.class
left join outcomes o 
	on s.name = o.ship
join t on c.class = t.class
where o.result = 'sunk'
group by c.class

select * from ships
--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).


select b.name from (select c.class,
					       a.name, 
					       c.numguns, 
					       c.displacement, 
					       rank() over(partition by c.displacement ORDER BY numguns desc) as num
						from classes c
					left join (select class, name from ships 
								union
							   select ship as class, ship as name from outcomes o) a
					on c.class = a.class
					) b
where b.num = 1
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with t as (select min(RAM) as ram from pc),
	 t1 as (select  pc.model, pc.speed, p.maker from pc, t, product p
	 		where t.ram = pc.ram and p.model = pc.model)
     t2 as (select max(speed) from t1)
select * from t2
select * from printer pr
	left join product p on p.model = pr.model 

	

--Классная работа:
--Компьютерная фирма: Найдите среднюю цену всех устройств, сгруппированую по производителям и типу . 
--Вывод: цена, производитель

with t as	(select model, price from pc
			union
			select model, price from printer p 
			union
			select model, price from laptop l)
select maker, avg(price) from product p 
left join t on p.model = t.model
group by maker, type

--task2
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL).
select * from ships
where class is not null

--task3
--Компьютерная фирма: Найти поставщиков/производителей компьютеров, моделей которых нет в продаже
-- (то есть модели этих поставщиков отсутствуют в таблице PC)


select distinct maker from product p 
left join pc on p.model = pc.model
where p.type = 'PC' and pc.model is null

--task4
--Компьютерная фирма: Найти модели и цены портативных компьютеров, стоимость которых превышает стоимость любого ПК

select model, price from laptop
where price > all (select price from pc)


--task5 +++
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), 
--имеющего самую высокую цену. Вывести: model

select model from (select model, price from pc
					union
					select model, price from printer p 
					union
					select model, price from laptop l
					order by price desc
					limit 1) t
					
--task6
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, 
--у кого цена больше 300 - "1", у остальных - "0"
select p.code, p.model, p.color, p.type, p.price,
	case
		when p.price > 300
		then '1'
		else '0'
	end dop
from printer p


--task7
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, 
--у кого цена вышей средней - "1", у остальных - "0"

with t as (select AVG(price) as price from printer)
select *,
case 
	when p.price > t.price
	then 1
	else 0
end dop
from printer p, t



--task9
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. 
--Вывод: model, maker

select distinct pc.model, p.maker
	from pc 
left join product p on pc.model = p.model
where pc.price > any(select price from printer)


--task10
--Компьютерная фирма: Вывести список всех уникальных продуктов и производителя в рамках БД. Вывести model, maker
with t as	(select model from pc
			union
			select model from printer p 
			union
			select model from laptop l)
select distinct t.model, maker from t 
left join product p on p.model = t.model

select distinct model, maker from product


--task11
--Корабли: Вывести список всех кораблей и класс. Для тех у кого нет класса - вывести 0, для остальных - class
select s.name, s.launched,
	case 
		when s.class is  null
		then '0'
		else s.class
	end clas
from ships s

task12
--Корабли: Для каждого класса определить год, когда был спущен на воду первый корабль этого класса. 
--Вывести: класс, год

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
-- и с самым быстрым процессором среди всех ПК, 
-- имеющих наименьший объем RAM. Вывести: Maker 
with t as (select min(RAM) as ram from pc),
	 t1 as (select  pc.model, pc.speed, p.maker from pc, t, product p
	 		where t.ram = pc.ram and p.model = pc.model)
     t2 as (select max(speed) from t1)
select * from t2
select * from printer pr
	left join product p on p.model = pr.model 


