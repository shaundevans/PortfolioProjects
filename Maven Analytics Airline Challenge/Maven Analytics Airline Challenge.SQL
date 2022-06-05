select * from airline_passenger_satisfaction_csv apsc 

/* General Exploration */ 
select satisfaction, avg("Departure and Arrival Time Convenience") as avg_dept_arr, avg("Ease of Online Booking") as easy_book,
avg("Check-in Service") as ci_rating, avg("Online Boarding") as OL_Board, avg("On-board Service") as OB_Service
from airline_passenger_satisfaction_csv apsc 
group by satisfaction 

/* Travel Demographics */ 
select "Type of Travel", avg("age"), "Customer Type", satisfaction
from airline_passenger_satisfaction_csv apsc 
group by "Type of Travel", "Customer Type", satisfaction 


select satisfaction, count(satisfaction), "Type of Travel", round(avg(age),2)
from airline_passenger_satisfaction_csv apsc 
group by satisfaction, "Type of Travel"

-- Null Value Check 
select * from airline_passenger_satisfaction_csv apsc 
where id is null 
or gender is null 
or "Customer Type" is null 
or "Type of Travel" is null 
or "Class" is null 
or "Flight Distance" is null 
or "Departure Delay" is null 
or "Arrival Delay" is null 
or "Departure and Arrival Time Convenience" is null 
or "Ease of Online Booking" is null 
or "Check-in Service" is null 
or "Online Boarding" is null 
or "Gate Location" is null 
or "On-board Service" is null 
or "Seat Comfort" is null 
or "Leg Room Service" is null 
or cleanliness is null 
or "Food and Drink" is null 
or "In-flight Wifi Service" is null 
or "In-flight Entertainment" is null 
or "Baggage Handling" is null 
or satisfaction is null 

-- There are 393 different passengers who did not respond/or had a null response to the "arrival delay"
select count(distinct(id)) from airline_passenger_satisfaction_csv apsc 
where "Arrival Delay" is null 

/* Creating a Table without Null Values */ 
create table clear_air as (
select * from airline_passenger_satisfaction_csv apsc 
where id is not null 
or gender is not null 
or "Customer Type" is not null 
or "Type of Travel" is not null 
or "Class" is not null 
or "Flight Distance" is not  null 
or "Departure Delay" is not null 
or "Arrival Delay" is not null 
or "Departure and Arrival Time Convenience" is not null 
or "Ease of Online Booking" is not null 
or "Check-in Service" is not null 
or "Online Boarding" is not null 
or "Gate Location" is not null 
or "On-board Service" is not null 
or "Seat Comfort" is not null 
or "Leg Room Service" is not null 
or cleanliness is not null 
or "Food and Drink" is not null 
or "In-flight Wifi Service" is not null 
or "In-flight Entertainment" is not null 
or "Baggage Handling" is not null 
or satisfaction is not null )

select * from clear_air

/* Getting Average Ratings for All Field (pivoted in Excel after export */ 
select satisfaction, round(avg("Departure and Arrival Time Convenience"),2) as trip_convenience, round(avg("Ease of Online Booking"),2) as booking, 
round(avg("Check-in Service"),2) as check_in, round(avg("Online Boarding"),2) as boarding, 
round(avg("Gate Location"),2) as gate, round(avg("On-board Service"),2) as OB_Service, round(avg("Seat Comfort"),2) as seat_comfort, 
round(avg("Leg Room Service"),2) as leg_room, round(avg(cleanliness),2) as avg_clean, round(avg("Food and Drink"),2) as food_drink, 
round(avg("In-flight Service"),2) as IF_Service, round(avg("In-flight Wifi Service"),2) as WIFI, round(avg("In-flight Entertainment"),2) as Entertainment, 
round(avg("Baggage Handling"),2) as baggage
from clear_air
group by satisfaction


/* Average Overall Score by Satisfaction -- Non-Weighted */

select satisfaction, Round(avg(("Departure and Arrival Time Convenience" + "Ease of Online Booking" + "Check-in Service" + "Online Boarding" + "Gate Location" + "Seat Comfort" + 
"Leg Room Service" + cleanliness + "Food and Drink" + "In-flight Service" + "In-flight Wifi Service" + "In-flight Entertainment" + "Baggage Handling")/13),2)
from clear_air 
group by satisfaction


/* Broad Demographic Group Scores*/ 
select satisfaction, Round(avg(("Departure and Arrival Time Convenience" + "Ease of Online Booking" + "Check-in Service" + "Online Boarding" + "Gate Location" + "Seat Comfort" + 
"Leg Room Service" + cleanliness + "Food and Drink" + "In-flight Service" + "In-flight Wifi Service" + "In-flight Entertainment" + "Baggage Handling")/13),2) as avg_rating, count(id) as total_customers,
case 
	when age <18 then 'Children'
	else 'Adults'
end as age_group 
from clear_air
group by satisfaction, age_group
order by satisfaction, age_group


/* Average Top Rankings */ 
select "Class", satisfaction, Round(avg(("Departure and Arrival Time Convenience" + "Ease of Online Booking" + "Check-in Service" + "Online Boarding" + "Gate Location" + "Seat Comfort" + 
"Leg Room Service" + cleanliness + "Food and Drink" + "In-flight Service" + "In-flight Wifi Service" + "In-flight Entertainment" + "Baggage Handling")/13),2)
from clear_air ca 
group by "Class", satisfaction

select * from clear_air ca 
