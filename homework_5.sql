--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице).
-- Вывод: все данные из laptop, номер страницы, список всех страниц
    CREATE PROC paging
      @n int =2 -- число записей на страницу, по умолчанию 2
    , @p int =1 -- номер страницы, по умолчанию - первая
    AS
    SELECT * FROM Laptop
    ORDER BY price DESC OFFSET @n*(@p-1) ROWS FETCH NEXT @n ROWS ONLY;

select * from laptop

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
create view distribution_by_type
as
select maker, 
	   type,
	   100 * (cast(a as float)/cast(b as float)) as proc
from 
(select distinct maker, type,
	   count(1) over (partition by maker, type) as a,
	   count(1) over (partition by maker) as b
	  from product) c

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words
as
(select * from ships
where name like '% %')

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
with t as (select name from ships where class is not null)
select ship from
  (select ship, null as class from outcomes o
  union
	select name as ship, class from ships) a 
where a.class is null and a.ship like 'S%' and a.ship not in (select * from t) 
  
 
--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). 
--Вывести model
with t as (select pr*,p.*,
				row_number () over (order by price desc) tmp
				from product pr
			join printer p
			on pr.model = p.model)
select model, price from t
where t.price > (case when (select avg(price) from t where maker = 'C') is null then 0 end) and t.maker = 'A'
union 
select model, price
from t
where t.price <= 3
















