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

select "rank", personname, age, finalworth, philanthropyscore
from forbes f 
where philanthropyscore is not null
order by philanthropyscore desc

-- Determining total philanthropic efforts based on Forbes Philanthropy Score metric as an aggregate dollar amount 
select "rank", personname, "age", finalworth, 
case 
	when philanthropyscore = 5 then (finalworth * .20)
	when philanthropyscore = 4 then (finalworth * .10)
	when philanthropyscore = 3 then (finalworth * .05)
	else finalworth * .01
end as donated_in_bil_low,
case 
	when philanthropyscore = 5 then (finalworth * .50)
	when philanthropyscore = 4 then (finalworth * .1999)
	when philanthropyscore = 3 then (finalworth * .999)
	else finalworth * .0499 
end as donated_in_bil_high,
philanthropyscore 
from forbes 
order by donated_in_bil_low desc 
limit 5

-- Number of Billionaires by Philanthropy Score Group
select count(personname), sum(finalworth) as totalnet, philanthropyscore, 
case 
	when philanthropyscore = 5 then (SUM(finalworth)*.2 + SUM(finalworth)*.5)/2
	when philanthropyscore = 4 then (SUM(finalworth)*.1 + SUM(finalworth)*.1999)/2
	when philanthropyscore = 3 then (SUM(finalworth)*.05 + sum(finalworth)*.0999)/2
	when philanthropyscore = 2 then (SUM(finalworth)*.01 + SUM(finalworth)*.0499)/2
	else SUM(finalworth)*.009999
end as total_donated_estimate
from forbes f 
where philanthropyscore is not null 
group by philanthropyscore 
order by philanthropyscore desc



-- Demographics of Billionaires
select sum(finalworth) as total_wealth, category from forbes f 
group by category 
order by total_wealth desc 


select avg(finalworth) as total_wealth, avg(philanthropyscore) as avg_phil_score,
case 
	when age <18 then '<18'
	when age >=18 and age <20 then '18-20'
	when age >=20 and age <30 then '20-30'
	when age >=30 and age <40 then '30-40'
	when age >=40 and age <50 then '40-50'
	when age >=50 and age <60 then '50-60'
	when age >=60 and age <70 then '60-70'
	when age >=70 then '>70'
end as demographics 
from forbes
where age is not null 
and philanthropyscore is not null
group by demographics 



select * from forbes

-- Average Philanthropy by Country 
select avg(finalworth) as total_wealth, avg(philanthropyscore) as avg_phil_score, country from forbes f
where philanthropyscore is not null 
group by country
order by avg_phil_score desc 
 

-- Top Non-US Philanthropists 
select personname, finalworth, country, philanthropyscore, 
case 
	when philanthropyscore = 5 then (finalworth * .20)
	when philanthropyscore = 4 then (finalworth * .10)
	when philanthropyscore = 3 then (finalworth * .05)
	else finalworth * .01
end as donated_in_bil_low,
case 
	when philanthropyscore = 5 then (finalworth * .50)
	when philanthropyscore = 4 then (finalworth * .1999)
	when philanthropyscore = 3 then (finalworth * .999)
	else finalworth * .0499 
end as donated_in_bil_high
from forbes 
where country not ilike '%United States%'
and philanthropyscore is not null 



select * from forbes f 
where countryofcitizenship not ilike '%United STates%'
order by finalworth desc 

-- Philanthopy by Industry

select avg(philanthropyscore) as avg_phil, count(philanthropyscore) as phil_by_ind, category from forbes f 
where philanthropyscore is not null 
group by category 
order by phil_by_ind desc 
limit 5


select * from forbes 
where personname ilike any(array['%bill gates%','%warren buffet%','%Mackenzie Scott%','%Elon Musk%','%Len Blavatnik%','Sam Bankman-Fried%','%Blair Parry-Okeden%','%Michael Kim%','%Michael Bloomberg%'])
