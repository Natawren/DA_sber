--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых принтеров по каждому типу (type)
select * from 
(select p.*,
	rank() over(partition by type order by price) as tmp
	from printer p) a
where tmp = 1

--task2  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому типу скорости
select * from 
( select pc.*, 
	rank() over(partition by speed order by price) as tmp
	from pc
) a 
where tmp =1

--task3  (lesson5)
-- Компьютерная фирма: Найти производителей, которые производят более 2-х моделей PC (через RANK, не having).
select distinct maker 
from
	(select p.*,
		   rank() over(partition by maker order by model) tmp
			from product p
	where type = 'PC') a
where tmp > 1
	
--task4 (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому производителю. Вывод: maker, code, price
select maker, code, price from 
(select p.maker, pc.code, pc.price,
	   rank() over(partition by p.maker order by pc.price) tmp
from product p 
join pc on pc.model = p.model) m
where tmp = 1

--task5 (lesson5)
-- Компьютерная фирма: Создать view (all_products_050521), в рамках которого будет только 2 самых дорогих товаров по каждому производителю
create view all_products_050521 as
with a as (select pc.model, pc.price from pc 
		union
		select pr.model, pr.price from printer pr 
		union 
		select l.model, l.price from laptop l), 
	b as (select pr.*, a.price,
		 rank() over(partition by pr.maker order by a.price desc) tmp
		from product pr
		join a
		 on a.model = pr.model)
select * from b
where tmp <= 2

--task6 (lesson5)
-- Компьютерная фирма: Сделать график со средней ценой по всем товарам по каждому производителю (X: maker, Y: avg_price) на базе view all_products_050521

--task7 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой на модели с таким же значением типа (type, в долях)
with t as
		(select p.*, b.min_price from printer p
		left join 
		(select type, price as min_price from 
		(select p.*,
			rank() over(partition by type order by price) as tmp
			from printer p) a
		where tmp = 1) b
		on p.type = b.type)
select distinct model, type,
				(price - min_price) as diff
	from t

--task8 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой на модели с таким же значением color (type, в долях)
with t as
		(select p.*, b.min_price from printer p
		left join 
		(select color, price as min_price from 
		(select p.*,
			rank() over(partition by color order by price) as tmp
			from printer p) a
		where tmp = 1) b
		on p.color = b.color)
select distinct model, color,
				(price - min_price) as diff
	from t

select *, 
price - min(price) over (partition by color) as delta_min 
from printer	
	
--task9 (lesson5)
-- Компьютерная фирма: Для каждого laptop  из таблицы laptop вывести три самых дорогих устройства (через оконные функции).
select model from 
	(select l.*,
			row_number() over (order by price desc) as tmp
			from laptop l) r
	where tmp <= 3

--task10 (lesson5)
-- Компьютерная фирма: Для каждого производителя вывести по три самых дешевых устройства в отдельное view (products_with_lowest_price).
create view products_with_lowest_price as
with a as (select pc.model, pc.price from pc 
		union
		select pr.model, pr.price from printer pr 
		union 
		select l.model, l.price from laptop l), 
	b as (select pr.*, a.price,
		 rank() over(partition by pr.maker order by a.price) tmp
		from product pr
		join a
		 on a.model = pr.model)
select * from b
where tmp <= 3

--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price
	
	
	
	