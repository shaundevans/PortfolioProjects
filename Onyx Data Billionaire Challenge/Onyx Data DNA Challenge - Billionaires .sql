/* Investigating data */ 
select * from forbes; 

-- Looking for nulls 

select * from forbes f 
where personname is null 
or "age" is null 
or "year" is null 
or finalworth is null 
or "month" is null 
or category is null 
or "source" is null 
or country is null 
or state is null 
or city is null 
or countryofcitizenship is null 
or organization is null 
or selfmade is null 
or gender is null 
or birthdate is null 
or title is null 
or philanthropyscore is null 
or residencemsa is null 
or numberofsiblings is null 
or bio is null 
or about is null 

-- We have quite a few different categories of data to investigate, so we'll go line by line

select * from forbes where "age" is null 

select * from forbes where finalworth is null 

select * from forbes where "year" is null 

select * from forbes where "month" is null 

select * from forbes where category is null 

select * from forbes where "source" is null 

select * from forbes where country is null 

select * from forbes where state is null 

select * from forbes where countryofcitizenship is null 

select * from forbes where organization is null 

select * from forbes where selfmade is null 

select * from forbes where gender is null 

select * from forbes where birthdate is null 

select * from forbes where title is null 

-- Leaving Nulls 
select * from forbes where philanthropyscore is null 

-- Leaving nulls 
select * from forbes where residencemsa is null 

-- Since there is not way to fix this, this will be left NULL 
select * from forbes where numberofsiblings is null 

select * from forbes where bio is null 

select * from forbes where about is null 



-- Updating Age for Individuals will Null Values (given the constraints of our data set, and source material, we'll be using google search to fill in the age nulls in this case)
/* No Known Age for the individuals not updated, retained as NULL
 * Age left Null for multiple parties/families/estates */ 
update forbes 
set "age" = (extract(year from current_date) - 1989)
where personname = 'Maximilian Viessmann'

update forbes
set "age" = (extract(year from current_date) - 1989)
where personname = 'Zong Yanmin'

update forbes 
set "age" = 50
where personname = 'Marcos Galperin'

update forbes 
set "age" = (extract(year from current_date)- 1949)
where personname = 'Maren Otto'

update forbes 
set "age" = 47
where personname = 'Benjamin Otto'

 
update forbes
set "age" = 69 
where personname = 'Chen Quiongxiang'

update forbes 
set "age" = (extract(year from current_date)-1986)
where personname = 'Christiane Schoeller'

update forbes 
set "age" = (extract(year from current_date)-1970)
where personname = 'Melissa Ma'



/* Billionaire Count by Country */ 
select count(personname) as n_billionaires, country
from forbes
group by country 
order by n_billionaires desc

/* Average Net Worth by Country */ 
select sum(finalworth)/count(personname) as avg_networth, country
from forbes 
group by country 
order by avg_networth desc 

-- Standard Deviation and Average Net Worth by Industry 
select stddev(finalworth) as std_dev, round(avg(finalworth)::int4,2) as avg_worth, category
from forbes f 
group by category 
order by std_dev desc, avg_worth desc 


select "rank", personname, "age", finalworth, philanthropyscore from forbes f 
order by finalworth desc 
limit 5




 


