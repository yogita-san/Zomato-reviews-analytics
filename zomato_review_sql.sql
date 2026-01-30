--Create Database
create database zomato_project

--Create Table
create table zomato_reviews(      

--For Import file
--(right click on databse->task->import flat file->next->given path and same table name which already I have created->
--selected datatype like  
--  review_id(nvarchar(max),not null),rating(int,not null),review_text(nvarchar(max),null),
-- 	review_date(datetime2(7),null),helpful(int,null)


use zomato_project
select * from zomato_reviews

--1) Total reviews
select COUNT(*) as total_reviews from zomato_reviews

--2) Average rating
select round(AVG(rating*1.00),2) as avg_rating from zomato_reviews

--3)Rating wise review count
select rating,count(*) as reviews from zomato_reviews
group by rating
order by rating desc

--4) Total positive reviews(rating>=4)
select count(*) as positive_reviews from zomato_reviews
where rating>=4

--5) Total negative reviews(rating<=2)
select COUNT(*) as negative_reviews from zomato_reviews
where rating<=2

--6) % of negative reviews
select round(SUM(case when rating<=2 then 1 else 0 end)*100/count(*),2)
as negative_percentage from zomato_reviews

--7) Most recet review date
select max(review_date) as latest_review_date
from zomato_reviews

--8) Oldest review date
select min(review_date) as latest_review_date
from zomato_reviews


--// MODERATE SQL PROJECT //

----9) Monthly review trend 
select year(review_date) as year,
       month(review_date) as month,
	   count(*) as total_reviews from zomato_reviews
group by year(review_date), month (review_date)
order by year,month

--10) Monthly compalint trend (rating<=2)
select year(review_date) as year,
       month(review_date) as month,
	   count(*) as complaints from zomato_reviews
where rating<=2
group by year(review_date), month (review_date)
order by year,month

--11) Helpful votes by rating
select rating,round(avg(helpful*1.00),2) as avg_helpful_votes
from zomato_reviews
group by rating
order by rating desc

--12) Top 10 most helpful reviews
select top 10 review_text,rating,helpful,review_date 
from zomato_reviews
order by helpful desc

--13) Avg helpful vote for negative reviews
select avg(helpful) as avg_helpful_negative 
from zomato_reviews
where rating<=2

--14) Customer satisfaction category
select case when rating>=4 then 'Satisfied'
            when rating=3 then 'Neutral'
			else 'Dissatisfied'
       end as customer_type,
	   count(*) as total_users 
  from zomato_reviews
  group by case when rating>=4 then 'Satisfied'
            when rating=3 then 'Neutral'
			else 'Dissatisfied'
       end

--15) Reviews with missing text
select count(*) as blank_reviews
from zomato_reviews
where review_text is null or LTRIM(rtrim(review_text))=''


--// ADVANCED SQL PROJECT//

--16) Running total of reviews
with monthly_reviews as(
     select
	        year(review_date) as year,
			month(review_date) as month,
			count(*) as total_reviews
	 from zomato_reviews
	 group by year(review_date),month(review_date)
)
select *,
sum(total_reviews) over(order by year,month) as running_total
from monthly_reviews
order by year,month

--17) Worst months by complaints(rating<=2)
with monthly_complaints as(
     select
	        year(review_date) as year,
			month(review_date) as month,
			count(*) as complaints
	 from zomato_reviews
	 where rating<=2
	 group by year(review_date),month(review_date)
)
select top 1 * from monthly_complaints
order by complaints desc

--18) Best month by positive reviews
with monthly_positive as(
     select
	        year(review_date) as year,
			month(review_date) as month,
			count(*) as positive_reviews
	 from zomato_reviews
	 where rating>=4
	 group by year(review_date),month(review_date)
)
select top 1 * from monthly_positive
order by positive_reviews desc

--19) Rank months by compalint count
with monthly_complaints as(
     select
	        year(review_date) as year,
			month(review_date) as month,
			count(*) as complaints
	 from zomato_reviews
	 where rating<=2
	 group by year(review_date),month(review_date)
)
select *,
RANK() over(order by complaints desc) as complaint_rank
from monthly_complaints

--20) % share of complaints each month
with monthly_complaints as(
     select
	        year(review_date) as year,
			month(review_date) as month,
			count(*) as complaints
	 from zomato_reviews
	 where rating<=2
	 group by year(review_date),month(review_date)
)
select *,
(complaints*100/sum(complaints)over()) as complaint_share_percentage
from monthly_complaints
order by year,month

----------------------------------***********-------------------------------------------






