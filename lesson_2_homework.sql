--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--Классная работа
-- Задание 18: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D'. Вывести model
--
with t as (select avg(pr.price) as price from printer pr
				left join product p on p.model = pr.model
			where p.maker = 'D' 
			group by maker)
select pr2.model from printer pr2, product p2, t
where p2.maker='A' and p2.model = pr2.model and pr2.price > t.price


-- Задание 19: Найдите производителей, которые производили бы как PC со скоростью (speed) не менее 750, так и laptop со скоростью (speed) не менее 750. Вывести maker
--
select distinct t.maker 
		from (select p.maker from pc
				join product p on pc.model = p.model 
				where pc.speed >= 750) t
			join
		 		(select p.maker from laptop l
		 		join product p on p.model = l.model 
				where l.speed >= 750) t1
		on t.maker = t1.maker

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select t.maker, avg(t.hd) 
	from (select p.maker, hd from pc
			join product p on pc.model = p.model) t
	join (select distinct p2.maker from product p2
			where p2.type = 'Printer') t1
	on t.maker = t1.maker
group by t.maker

--Домашняя работа:
-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select s.name, s.class
	from ships s
where s.launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select s.name, s.class 
	from ships s
where s.launched > 1920 and s.launched < 1942
-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select s.class, count(distinct(s.name))
	from ships s
group by s.class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select distinct c.class, c.country
	from classes c
where c.bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship 
from outcomes o 
where o.result = 'sunk' 
  and o.battle = 'North Atlantic'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select o.ship 
	from outcomes o
left join battles b 
	on o.battle = b.name
where o.result = 'sunk'
order by b.date desc
limit 1

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
select o.ship, s.class
	from outcomes o
left join battles b 
	on o.battle = b.name
left join ships s 
	on o.ship = s.name
where o.result = 'sunk'
order by b.date desc
limit 1

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select s.name, s.class
	from ships s
left join classes c on s.class = c.class
left join outcomes o on s.name = o.ship 
where c.bore >= 16 and o.result = 'sunk'

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select distinct class from classes c
where c.country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select s.name, s.class
	from classes c
left join ships s on c.class = s.class
where c.country = 'USA'




