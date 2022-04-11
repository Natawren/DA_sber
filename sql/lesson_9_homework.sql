--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when grade >=8
            then name
            else NULL
        end,
        grade, 
        marks from students, grades 
where marks between min_mark and max_mark
order by grade desc, name, marks;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station
where NOT regexp_like(lower(city),'^[aeiou]');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct city from station
where NOT regexp_like(lower(city),'*[aeiou]$');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct city from station
where NOT regexp_like(lower(city),'^[aeiou].*[aeiou]$');
--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct city from station
where  regexp_like(lower(city),'^[^aeiou].*[^aeiou]$');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from employee
where months < 10 and salary > 2000;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when grade >=8
            then name
            else NULL
        end,
        grade, 
        marks from students, grades 
where marks between min_mark and max_mark
order by grade desc, name, marks;

