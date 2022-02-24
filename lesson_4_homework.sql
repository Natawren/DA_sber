--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--Домашняя работа:


--task13
--Компьютерная фирма: Вывести список всех продуктов и происзводителя с указанием типа продукта (pc, printer, laptpo). Вывести: model, maker, type
select * from product

--task14
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
with t as (select avg(price) as avg_price from pc)
select pr.*, 
	 case 
	 	when pr.price < t.avg_price
	 	then 0
	 	else 1
	 end dif
  from printer pr, t


--task15
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
  
  select name from ships s 
  where class is null

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)
  with t as (select distinct launched from ships)
  select distinct name from battles b 
  where extract(year from date) not in (select * from t)
  
--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

with t as (select name from ships where class = 'Kongo')

select distinct battle from outcomes o
 where o.ship in (select * from t)



--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300
as
(select a.model, a.price,
	case 
		when a.price > 300
		then 1
		else 0
	end flag
	from 
		(select pc.model, pc.price from pc 
		union
		select pr.model, pr.price from printer pr 
		union 
		select l.model, l.price from laptop l) a)

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price
as
(
with t as (select pc.model, pc.price from pc 
			union
			select pr.model, pr.price from printer pr 
			union 
			select l.model, l.price from laptop l),
	 t1 as (select avg(price) as avg_price from t)
select t.model, t.price,
	case 
		when t.price > (select * from t1)
		then 1
		else 0
	end flag
	from t
)
--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with t as (select p.*, pr.maker from product pr
			join printer p on pr.model = p.model),
	t1 as (select avg(price) from t
			where t.maker = 'D' or t.maker = 'C')
	select * from t
	where maker = 'A' and price > (select * from t1)
--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди  продуктов производителя = 'A' (printer & laptop & pc) - является что уникальным продуктом
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
	
--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view  count_products_by_makers
as
	(select pr.maker, count(1)
			from product pr
		left join 
				(select pc.model, pc.price from pc 
				union
				select pr.model, pr.price from printer pr 
				union 
				select l.model, l.price from laptop l) a
		 on a.model = pr.model 	
	group by maker)


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated
as
(select pr.* from printer pr
join product p on pr.model = p.model
where p.maker != 'D')

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers
as
(select pu.*, p.maker from printer_updated pu
left join product p on pu.model = p.model)

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes
as
select class,
	   case when result is null
	   		then 0
	   		else result
	   end
from
(	select c.class, count(o.result) as result
		from classes c
	left join ships s 
		on s.class = c.class
	left join outcomes o 
		on s.name = o.ship
	where o.result = 'sunk' or o.result is NULL
	group by c.class
) a

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag
as
(select c.*,
	case when c.numguns >= 9
	then 1
	else 0
	end flag
from classes c)


--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select * from ships
where name like 'O%' or name like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(1) from ships s 
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)



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

