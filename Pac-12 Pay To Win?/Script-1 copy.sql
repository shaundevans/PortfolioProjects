/* Using Union to join tables without duplicative data (since each table is unique for the county it represents vs. join) */

create table all_data as 
select * from "AlamedaCounty_2020" ac 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "BentonCounty_2020" bc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "BoulderCounty_2020" bc2 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "KingCounty_2020" kc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "LaneCounty_2020" lc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "LosAngeles_2020" la 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "MaricopaCounty_2020" mc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "PimaCounty_2020" pc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "SaltLakeCounty_2020" slc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "SantaClaraCounty_2020" scc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'
union 
select * from "WhitmanCounty_2020" wc 
where industry_code = '10'
and agglvl_title like '%Total Covered%'

/* creating a separate table with 2020 win and loss totals to join with temp table */
create table wins_losses(
area_title varchar(100), 
team varchar(100),
wins_2020 int, 
losses_2020 int, 
tie_2020 int
)

insert into wins_losses(area_title, team, wins_2020, losses_2020, tie_2020) 
values('Santa Clara County, California','Stanford','3','9','0'), 
('King County, Washington','Washington','4','8','0'), 
('Alameda County, California','California','5','7','0'), 
('Boulder County, Colorado','Colorado','4','8','0'),
('Los Angeles County, California', 'USC', '4','8','0'), 
('Los Angeles County, California', 'UCLA', '8','4','0'),
('Salt Lake County, Utah', 'Utah', '10','4','0'),
('Maricopa County, Arizona','Arizona State','8','5','0'),
('Benton County, Oregon', 'Oregon State', '7','6','0'), 
('Whitman County, Washington','Washington State','5','7','0'),
('Pima County, Arizona','Arizona','1','11','0'), 
('Lane County, Oregon', 'Oregon','10','4','0')



select * from wins_losses
order by wins_2020 desc

 

/* Table of income weekly and annually by county  joining win and loss records */
select ad.area_title, wl.team, ad.annual_avg_wkly_wage, ad.avg_annual_pay, wl.wins_2020, wl.losses_2020
from all_data as ad
join wins_losses as wl on wl.area_title = ad.area_title
order by annual_avg_wkly_wage desc 


/* using correlation calculation in postgresql */
select ad.area_title, wl.wins_2020, ad.annual_avg_wkly_wage, corr(ad.annual_avg_wkly_wage,wl.wins_2020) as win_corr
from all_data as ad
join wins_losses as wl on wl.area_title = ad.area_title
group by ad.area_title, wl.wins_2020, ad.annual_avg_wkly_wage


/* changes in income during 2020 */
select ad.area_title, wl.team, wl.wins_2020, wl.losses_2020, ad.annual_avg_emplvl, ad.oty_annual_avg_emplvl_chg, ad.oty_annual_avg_emplvl_pct_chg from all_data as ad
join wins_losses as wl on wl.area_title = ad.area_title
order by ad.oty_annual_avg_emplvl_pct_chg desc


select * from all_data ad 

/* wage changes by school county */
select ad.area_title, wl.team, wl.wins_2020, ad.oty_annual_avg_wkly_wage_chg, ad.oty_annual_avg_wkly_wage_pct_chg, (ad.oty_annual_avg_wkly_wage_chg/wl.wins_2020) as "wage increase per win",  from all_data as ad
join wins_losses as wl on wl.area_title = ad.area_title 
order by ad.oty_annual_avg_wkly_wage_pct_chg desc

/* top and bottom industries by school county */

select * from top_five_industries 


create table top_five_industries as 
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg as top_five from "AlamedaCounty_2020"
where industry_title like 'NAICS%'
and industry_code not in ('48849')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "BentonCounty_2020" bc 
where industry_title like 'NAICS%'
and industry_code not in ('62412')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "BoulderCounty_2020" bc 
where industry_title like 'NAICS%'
and industry_code not in ('1123','92313', '1125','11231','112519','923','923130','111998')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title,industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "KingCounty_2020" kc 
where industry_title like 'NAICS%'
and industry_code not in ('923140','6211','621111','62211','622110')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union 
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "LaneCounty_2020" lc 
where industry_title like 'NAICS%'
and industry_code not in ('62412','562','5622','562212')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from  "LosAngeles_2020" la 
where industry_title like 'NAICS%'
and industry_code not in ('561790','92613')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from  "MaricopaCounty_2020" mc 
where industry_title like 'ovNAICS%' 
and industry_code not in ('62211','6221','62210','8139','813910','424590','622','523120')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "PimaCounty_2020" pc 
where industry_title like '%NAICS%' 
and industry_code not in ('54','5417','541714','4413','44131','442','44229','4422','442299','445','44511','445110')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from  "SaltLakeCounty_2020" slc 
where industry_title like '%NAICS%' 
and industry_code not in ('336360','42459','3369')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from  "SantaClaraCounty_2020" scc 
where industry_title like '%NAICS%'
and industry_code not in  ('523120','5231','3325','11119','332510')
order by oty_annual_avg_estabs_count_pct_chg desc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from  "WhitmanCounty_2020" wc 
where industry_title like '%NAICS%' 
and industry_code not in ('523120','5231','238351')
order by oty_annual_avg_estabs_count_pct_chg desc 
limit 5)



select * from top_five_industries tfi 
join wins_losses as wl on wl.area_title = tfi.area_title 
order by wl.wins_2020 desc, team

/* Bottom Five */

(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg as bottom_five from "AlamedaCounty_2020"
where industry_title like '%NAICS%' 
and industry_code not in ('33632','11299','453930')
order by oty_annual_avg_estabs_count_pct_chg asc
limit 5)
union
(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "BentonCounty_2020" bc 
where industry_title like '%NAICS%' 
and industry_code not in ('2213','22132','323120')
order by oty_annual_avg_estabs_count_pct_chg asc
limit 5)

(select area_title, industry_code, industry_title, oty_annual_avg_estabs_count_pct_chg from "BoulderCounty_2020" bc 
where industry_title like '%NAICS%' 
and industry_code not in ('52','922')
order by oty_annual_avg_estabs_count_pct_chg asc
limit 5)


