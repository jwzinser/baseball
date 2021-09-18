select *, (select sum(case when wswi.name=wsw.name then year else 0 end) from wsw as wswi where wswi.year between wsw.year-7 and wsw.year+1 )  from wsw;

select * from (select *, (select sum(case when wswi.name=wsw.name then year else 0 end)  as s from wsw as wswi where wswi.year between wsw.year-9 and wsw.year )  from wsw) as d where s > 5000;


select wsw.year, wsw.name, 
sum(case when wswi.name=wsw.name then wswi.year else 0 end)  as s ,
sum(case when wswi.name=wsw.name then 1 else 0 end)  as s ,
min(case when wswi.name=wsw.name then wswi.year else null end)  as s 

from wsw as wswi inner join wsw  on wswi.year between wsw.year-9 and wsw.year group by wsw.year, wsw.name order by wsw.year;


create or replace view cw as
select wsw.year, wsw.name, 
sum(case when wswi.name=wsw.name then 1 else 0 end)  as n ,
min(case when wswi.name=wsw.name then wswi.year else null end)  as miny 
from wsw as wswi inner join wsw  on wswi.year between wsw.year-9 and wsw.year group by wsw.year, wsw.name order by wsw.year;


select name,miny,max(n), max(year) from 
cw  group by name, miny order by max(year)  ;


select name,miny, max(year) from 
cw where n>2 group by name, miny order by max(year)  ;



-- hacerlo hacia atras y agrupar por fecha que inicia la cuenta
create or replace view cw2 as
select year, name,miny, n from (select   wsw.year, wsw.name, wswi.year as year2, wswi.name   as name2,
  sum( case when wsw.name=wswi.name then 1 else 0 end ) over (partition by wsw.year order by  wswi.year  rows 9 preceding) as n,
  min(case when wswi.name=wsw.name then wswi.year else null end) over (partition by wsw.year rows 9 preceding) as miny
   from wsw cross join wsw as wswi 
   where wswi.year<= wsw.year order by wsw.year, wswi.year )  as ss where year=year2;
   
-- same but mysql 5.7
create or replace view cw3 as
select year, name,miny, n from (select   wsw.year, wsw.name,
  sum( case when wsw.name=wswi.name then 1 else 0 end )  as n,
  min(case when wswi.name=wsw.name then wswi.year else null end)  as miny
   from wsw cross join wsw as wswi 
   where wswi.year > (wsw.year-10) and wswi.year < (wsw.year+1) group by wsw.year, wsw.name  order by wsw.year )  as ss ;

/*
cw3
|--------+------------------+--------+-----|
| 1923   | New York Yankees | 1923   | 1   |
| 1927   | New York Yankees | 1923   | 2   |
| 1928   | New York Yankees | 1923   | 3   |
| 1932   | New York Yankees | 1923   | 4   |
| 1936   | New York Yankees | 1927   | 4   |
| 1937   | New York Yankees | 1928   | 4   |
| 1938   | New York Yankees | 1932   | 4   |
| 1939   | New York Yankees | 1932   | 5   |
| 1941   | New York Yankees | 1932   | 6   |
| 1943   | New York Yankees | 1936   | 6   |
| 1947   | New York Yankees | 1938   | 5   |
| 1949   | New York Yankees | 1941   | 4   |
| 1950   | New York Yankees | 1941   | 5   |
| 1951   | New York Yankees | 1943   | 5   |
| 1952   | New York Yankees | 1943   | 6   |
| 1953   | New York Yankees | 1947   | 6   |
| 1956   | New York Yankees | 1947   | 7   |
| 1958   | New York Yankees | 1949   | 7   |
| 1961   | New York Yankees | 1952   | 5   |
| 1962   | New York Yankees | 1953   | 5   |
| 1977   | New York Yankees | 1977   | 1   |
| 1978   | New York Yankees | 1977   | 2   |
| 1996   | New York Yankees | 1996   | 1   |
| 1998   | New York Yankees | 1996   | 2   |
| 1999   | New York Yankees | 1996   | 3   |
| 2000   | New York Yankees | 1996   | 4   |
| 2009   | New York Yankees | 2000   | 2   |
+--------+------------------+--------+-----+
*/
select name,miny, max(n) from 
cw2 where n>2 group by name, miny order by miny  ;

select name,miny, max(n) from 
cw3 where n>2 and name like '%ankee%' group by name, miny order by miny  ;

/*
| name             | miny   | max   |
|------------------+--------+-------|
| New York Yankees | 1923   | 4     |
| New York Yankees | 1927   | 4     |
| New York Yankees | 1928   | 4     |
| New York Yankees | 1932   | 6     |
| New York Yankees | 1936   | 6     |
| New York Yankees | 1938   | 5     |
| New York Yankees | 1941   | 5     |
| New York Yankees | 1943   | 6     |
| New York Yankees | 1947   | 7     |
| New York Yankees | 1949   | 7     |
| New York Yankees | 1952   | 5     |
| New York Yankees | 1953   | 5     |
| New York Yankees | 1996   | 4     |
+------------------+--------+-------+
*/




-- hacerlo hacia adelante y agrupar por fecha que culmina la cuenta
create or replace view cw3 as
select year, name,maxy, n from (select   wsw.year, wsw.name, wswi.year as year2, wswi.name   as name2,
  sum( case when wsw.name=wswi.name then 1 else 0 end ) over (partition by wsw.year order by  wswi.year  rows between current row and 9 following) as n,
  max(case when wswi.name=wsw.name then wswi.year else null end) over (partition by wsw.year   rows between current row and 9 following ) as maxy
   from wsw cross join wsw as wswi 
   where wswi.year>= wsw.year order by wsw.year, wswi.year )  as ss where year=year2;


select name,maxy, max(n) from 
cw3 where n>2 group by name, maxy order by maxy  ;




-- do one for consecutive wins, keeping first ocurrence
-- if grp is equal for consecutive years, means it is same name
create or replace view cw4 as
select wsw.*, row_number() over (order by year) as rn,row_number() over (partition by name order by year) as rnn,
             (row_number() over (order by year) -
              row_number() over (partition by name order by year)
             ) as grp
      from wsw;

select name, count(*), min(year)
from cw4
group by grp, name order by min(year);
