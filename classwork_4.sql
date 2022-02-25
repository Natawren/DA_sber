--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing




--Классная работа 
--task1  (lesson4)
-- Корабли: Вывести список кораблей, у которых начинается с буквы "S"
select * from ships where name like 'S%'

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_with_flag_speed_price) над таблицей PC c флагом: flag = 1 для тех, у кого speed > 500 и price < 900, для остальных flag = 0

create view pc_with_flag_speed_price
as 
	select pc.*,
		   case 
		   		when pc.speed > 500 and pc.price < 900
		   		then 1
		   		else 0
		   end	
	from pc 
	
	
--task3  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_maker_a) со всеми товарами производителя A. В view должны быть следующие колонки: model, price
	create view pc_maker_a
	as
		select pr.model, a.price 
			from product pr
		left join 
				(select pc.model, pc.price from pc 
				union
				select pr.model, pr.price from printer pr 
				union 
				select l.model, l.price from laptop l) a
		 on a.model = pr.model 
		where pr.maker = 'A'

--task4 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы laptop (название: laptop_under_1000) и удалить из нее все товары с ценой выше 1000.
		
	create table laptop_under_1000
	as
		(select * from laptop where price <= 1000)

--task5 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой и количеством по каждому производителю. (дубликаты можно учитывать).
create table all_products
as
(with t as	(select pr.maker,pr.type,  pr.model, a.price
				from product pr
			left join 
					(select pc.model, pc.price from pc 
					union
					select pr.model, pr.price from printer pr 
					union 
					select l.model, l.price from laptop l) a
			 on a.model = pr.model )
select  maker,
		avg(price) as avg_price,
		max(price) as max_price,
		count(1) as count_product
from t
group by maker)
		
--task6 (lesson4)
-- Компьютерная фирма: Построить по all_products график в colab/jupyter (X: maker, Y: средняя цена)

--task8 (lesson4)
-- Компьютерная фирма: Сделать view (название products_price_categories), в котором по всем продуктам нужно посчитать количество продуктов всего в зависимости от цены:
-- Если цена > 1000, то category_price = 2
-- Если цена < 1000 и цена > 500, то  category_price = 1
-- иначе category_price = 0
-- Вывести: category_price, count
create view products_price_categories
as
(with t as	(select 
				case 
					when a.price > 1000
					then 2
					when a.price <1000 and a.price > 500
					then 1
					else 0
				end category_price
				from product pr
			left join 
					(select pc.model, pc.price from pc 
					union
					select pr.model, pr.price from printer pr 
					union 
					select l.model, l.price from laptop l) a
			 on a.model = pr.model)
select category_price, count(category_price) from t
group by category_price
order by category_price)


--task9 (lesson4)
-- Сделать предыдущее задание, но дополнительно разбить еще по производителям (название products_price_categories_with_makers). Вывести: category_price, count, price
create view products_price_categories_with_makers
as
(with t as	(select pr.maker,
				case 
					when a.price > 1000
					then 2
					when a.price <1000 and a.price > 500
					then 1
					else 0
				end category_price
				from product pr
			left join 
					(select pc.model, pc.price from pc 
					union
					select pr.model, pr.price from printer pr 
					union 
					select l.model, l.price from laptop l) a
			 on a.model = pr.model)
select category_price, maker, count(category_price) from t
group by category_price, maker
order by category_price)


--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)
create table ships_without_n
as
(select * from ships s 
where s.name not like 'N%')