-Классная работа:
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

--Ушло в дз 4 заданий
--task13
--Компьютерная фирма: Вывести список всех продуктов и происзводителя с указанием типа продукта (pc, printer, laptpo). Вывести: model, maker, type

--task14
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

--task15
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.