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

-- Many of our null values are due to familial/sibling/spousal holdings.  We won't be able to correct these as a single age unless the individuals are listed 
select * from forbes 
where personname ilike any(array['%Beate Heister%', '%Karl Albrect%', '%Hank Meijer%',
'%Doug Meijer%', '%Doug Meijer%', '%Rober Ng%','%Philip Ng%', '%Hinduja%', '%Tom Love%','%Judy Love%', 
'%Ian Livingstone%', '%Richard Livingstone%', '%Bajaj%', '%von Finck%', '%resnick%', '%%Safra%', '%John Wilson%', '%Alan Wilson%', 
'%bruce Wilson%', '%Kwee%','%Yiwen%', '%Bhatia%'])




