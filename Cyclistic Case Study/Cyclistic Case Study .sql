/* Cyclistic case Study */ 

/* general exploration */ 
select * from may_20 m 

select * from jun_20 

select * from jul_20 j 

select * from aug_20 a 

select * from sep_20 s 

select * from oct_20 o 

select * from nov_20 n 

select * from dec_20 d 

select * from jan_21 j 

select * from feb_21 f 

select * from mar_21 m 


/*  key observation is that all of our tables have the same fields, so a union to create one file can occur since they all have the same column titles/data formats */

create table all_data as 
select * from may_20 m 
union 
select * from jun_20 j 
union 
select * from jul_20 j2 
union 
select * from aug_20 a 
union 
select * from sep_20 s 
union 
select * from oct_20 o 
union 
select * from nov_20 n 
union 
select * from dec_20 d 
union 
select * from jan_21 j3 
union 
select * from feb_21 f 
union 
select * from mar_21 m2 


/* Cleaning for any null, na, or unknown values that may skew rider behavior incorrectly.  Will also view any illogical values in data set to determine if anything needs to be dropped */ 

select * from all_data 
where ride_id is null
or rideable_type is null 
or started_at is null 
or ended_at is null 
or start_station_name is null 
or start_station_id is null 
or end_station_name is null 
or end_station_id is null 
or start_lat is null 
or start_lng is null 
or end_lat is null 
or end_lng is null 
or member_casual is null 
or ride_length is null 
or day_of_week is null
or month_name is null 

/* filtering our null fields */ 

create table ad_nonull as 
select * from all_data 
where ride_id is not null
or rideable_type is not null 
or started_at is not null 
or ended_at is not null 
or start_station_name is not null 
or start_station_id is not null 
or end_station_name is not null 
or end_station_id is not null 
or start_lat is not null 
or start_lng is not null 
or end_lat is not null 
or end_lng is not null 
or member_casual is not null 
or ride_length is not null 
or day_of_week is not null
or month_name is not null 

select * from ad_nonull 
	
/* Identifying other anomalies (i.e. 'unknown' or 'na')*/ 
select rideable_type from ad_nonull
group by rideable_type

/* It appears there are a significant number of 'unknown' start_station_name items in the data, which we'll investigate */
select start_station_name, count(start_station_name) from ad_nonull 
group by start_station_name 
order by count(start_station_name) desc


/* It's clear that there is a significant issue with GPS tracking amongst electric bikes, which are operated at a significantly higher rate by casual riders -- this will skew our analysis*/ 
select rideable_type, member_casual, count(rideable_type) as total
from ad_nonull 
where start_station_name in (select start_station_name from ad_nonull where start_station_name ilike 'unknown')
group by rideable_type, member_casual 

select * from ad_nonull
where start_station_name ilike 'unknown'


/* creating a table for investigation of the anomalies including all the 'unknown' and 'na' station data */ 
create table station_unknown as 
select * from ad_nonull 


/* cleaned data with our information that is currently usable */ 
create table station_known as 
select * from ad_nonull 

delete from station_known 
where start_station_name ilike any(array['%unknown%','%na%'])
or start_station_id ilike any(array['%unknown%','%na%'])
or end_station_name ilike any(array['%unknown%','%na%'])
or end_station_id ilike any(array['%unknown%','%na%'])

/* indetifying cases where the end time is earlier than the start time  and clearing these */ 
select * from station_known sk 
where ended_at::timestamp < started_at::timestamp

delete from station_known 
where ended_at::timestamp < started_at::timestamp 

select * from station_known sk 

/* adding some additional fields to improve analysis */ 
create table ad_days_dates as 
select ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual, 
(ended_at::timestamp - started_at::timestamp) as ride_length, 
case 
	when extract(dow from started_at::timestamp) = 0 then 'Sunday'
	when extract(dow from started_at::timestamp) = 1 then 'Monday'
	when extract(dow from started_at::timestamp) = 2 then 'Tuesday'
	when extract(dow from started_at::timestamp) = 3 then 'Wednesday'
	when extract(dow from started_at::timestamp) = 4 then 'Thursday'
	when extract(dow from started_at::timestamp) = 5 then 'Friday'
	when extract(dow from started_at::timestamp) = 6 then 'Saturday'
end as start_day, 
case 
	when extract(dow from ended_at::timestamp) = 0 then 'Sunday'
	when extract(dow from ended_at::timestamp) = 1 then 'Monday'
	when extract(dow from ended_at::timestamp) = 2 then 'Tuesday'
	when extract(dow from ended_at::timestamp) = 3 then 'Wednesday'
	when extract(dow from ended_at::timestamp) = 4 then 'Thursday'
	when extract(dow from ended_at::timestamp) = 5 then 'Friday'
	when extract(dow from ended_at::timestamp) = 6 then 'Saturday'
end as end_day, 
case 
	when extract(month from started_at::timestamp) = 1 then 'January'	
	when extract(month from started_at::timestamp) = 2 then 'February'	
	when extract(month from started_at::timestamp) = 3 then 'March'	
	when extract(month from started_at::timestamp) = 4 then 'April'	
	when extract(month from started_at::timestamp) = 5 then 'May'	
	when extract(month from started_at::timestamp) = 6 then 'June'	
	when extract(month from started_at::timestamp) = 7 then 'July'	
	when extract(month from started_at::timestamp) = 8 then 'August'	
	when extract(month from started_at::timestamp) = 9 then 'September'	
	when extract(month from started_at::timestamp) = 10 then 'October'	
	when extract(month from started_at::timestamp) = 11 then 'November'	
	when extract(month from started_at::timestamp) = 12 then 'December'	
end as started_month, 
case 
	when extract(month from ended_at::timestamp) = 1 then 'January'	
	when extract(month from ended_at::timestamp) = 2 then 'February'	
	when extract(month from ended_at::timestamp) = 3 then 'March'	
	when extract(month from ended_at::timestamp) = 4 then 'April'	
	when extract(month from ended_at::timestamp) = 5 then 'May'	
	when extract(month from ended_at::timestamp) = 6 then 'June'	
	when extract(month from ended_at::timestamp) = 7 then 'July'	
	when extract(month from ended_at::timestamp) = 8 then 'August'	
	when extract(month from ended_at::timestamp) = 9 then 'September'	
	when extract(month from ended_at::timestamp) = 10 then 'October'	
	when extract(month from ended_at::timestamp) = 11 then 'November'	
	when extract(month from ended_at::timestamp) = 12 then 'December'	
end as ended_month
from station_known sk 


/* Additional Cleaning to identify/remove any remaining Illogical Values */

select * from ad_days_dates
where started_month <> ended_month 

select member_casual, rideable_type, max(ride_length), min(ride_length)
from ad_days_dates
group by rideable_type, member_casual

/* There's quite a few '0' minute rides in our data, primarily from casual riders, since this may indicate a POS/Churn type behavior, will leave in our reporting, but will investigate */ 
select member_casual, count(ride_length)
from ad_days_dates 
where ride_length = (select min(ride_length) from ad_days_dates )
group by member_casual

/* removing zero time rides */ 
create table ad_no_zero as 
select * from ad_days_dates 
where ride_length <> (select min(ride_length) from ad_days_dates)


select member_casual, rideable_type, min(ride_length) from ad_no_zero 
group by member_casual, rideable_type



/* Report Creation -- CSVs that will be exported */ 

/* Day of Week Habits */ 
select member_casual, start_day, count(ride_id), avg(ride_length) as avg_ride
from ad_days_dates 
group by member_casual, start_day


select member_casual, end_day, count(ride_id)
from ad_days_dates 
group by member_casual, end_day

/* DOW Usage and Type/Time */ 
select member_casual, rideable_type, count(rideable_type) as n_rides, avg(ride_length) as avg_ride, start_day 
from ad_days_dates
group by member_casual, rideable_type, start_day


/* seasonality */ 
select member_casual, started_month, rideable_type, count(rideable_type) as n_rides, avg(ride_length) as avg_ride
from ad_days_dates 
group by member_casual, rideable_type, started_month
order by member_casual desc 

select member_casual, count(ride_id), started_month
from ad_days_dates 
group by member_casual, started_month
order by member_casual desc, started_month 


/* Ridership by month */ 
select member_casual, count(ride_id) as n_rides, started_month
from ad_days_dates 
group by started_month, member_casual 
order by n_rides desc

/* Route Popularity */
select start_station_name, end_station_name, count(ride_id) as n_rides
from ad_days_dates 
group by start_station_name, end_station_name 
order by n_rides desc

/* Rout Popularity by Day/Month */

select start_station_name, end_station_name, count(ride_id) as n_rides, start_day, started_month, avg(ride_length)
from ad_days_dates 
where start_station_name not ilike '%WATSON TESTING%'
group by start_station_name, end_station_name, start_day, started_month 
order by n_rides desc

/* Route Populartity by membership, ridable type, and month */
select member_casual, rideable_type, start_station_name, count(ride_id) as n_start, end_station_name, started_month, avg(ride_length) as avg_ride
from ad_days_dates  
group by member_casual, rideable_type, start_station_name, end_station_name, started_month
order by member_casual desc, n_start desc, started_month desc


select member_casual, avg(extract(epoch from ride_length)/60::int) as rl_int, rideable_type, started_month, count(ride_id) from ad_days_dates 
group by member_casual, rideable_type, started_month
order by started_month

select member_casual, avg(ride_length) as rl_int, rideable_type, started_month, count(ride_id) from ad_days_dates 
group by member_casual, rideable_type, started_month
order by started_month