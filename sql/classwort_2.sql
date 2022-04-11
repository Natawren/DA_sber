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