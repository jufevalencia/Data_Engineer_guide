
SELECT *
FROM users
WHERE mail REGEXP '^[a-zA-Z][a-zAZ0-9_.-]*@leetcode[.]com'


-------


select product_name , sum(unit) as unit 
from orders 
inner join products
on orders.product_id = products.product_id
where DATE_FORMAT(order_date, '%Y-%m')  = "2020-02" 
group by product_name
having sum(unit) >= 100

------


select sell_date, count( DISTINCT product ) as num_sold ,
    
    GROUP_CONCAT( DISTINCT product order by product ASC separator ',' ) as products
    
        FROM Activities GROUP BY sell_date order by sell_date ASC;


--------


SELECT MAX(Salary) AS SecondHighestSalary 
FROM Employee
WHERE Salary NOT IN (
    SELECT MAX(Salary) FROM Employee
)


------

with duplicates as (
  select id , email ,
  row_number() over (partition  by email order by id asc) as top 
  from person


)


delete from person
where  id in (select id from duplicates where top <> 1)


------


select user_id , concat(upper(substring(name,1,1)),lower(substring(name, 2))) as name
from 
Users
order by user_id 

----------


with salaries as (

select salary , departmentId, id, name,
      DENSE_RANK() over( partition by departmentId order by salary desc) as top 
       from employee 

)

select department.name  as Department, salaries.name as Employee, salary as Salary
from 
salaries
inner join 
department on salaries.departmentId = department.id 
where 
top <= 3


-------

select round(sum(tiv_2016)  ,2 ) as tiv_2016
from 
Insurance
where 
tiv_2015  in (select tiv_2015 from insurance group by tiv_2015 having count(tiv_2015) > 1)
and concat(lat,lon) not in  (select concat(lat,lon) as ubication   from insurance group by  concat(lat,lon) having count(1) > 1 
)
 




-----


WITH cte AS

(SELECT visited_on, SUM(amount) AS total_amount

FROM Customer

GROUP BY  visited_on),



cte2 AS

(SELECT

  a.visited_on,

  SUM(b.total_amount) AS amount,

  ROUND(SUM(b.total_amount)/7,2) AS average_amount

FROM cte a, cte b

WHERE DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6

GROUP BY a.visited_on

ORDER BY a.visited_on)



SELECT *

FROM cte2

WHERE visited_on >= (SELECT visited_on FROM cte ORDER by visited_on LIMIT 1 ) + 6

ORDER BY visited_on


--------



select id, 
coalesce(case when id%2=0 then lag(student) over() else lead(student) over() end, student) as student
from seat

-----


select employees.employee_id
from employees
where employees.salary < 30000 and employees.manager_id not in (select distinct(employee_id) from employees)
order by employee_id asc 

--------

with salaries as (
select  
Case 
      when income < 20000 then "Low Salary"
      when income >= 20000 and income <= 50000 then "Average Salary"
      else "High Salary" end as Category
from accounts 
)
,
Categories AS (
SELECT 'Low Salary' AS category
UNION
SELECT 'Average Salary' AS category
UNION
SELECT 'High Salary' AS category
)

select categories.category , count(salaries.Category) as accounts_count
from 
categories 
left join
salaries 
on categories.category = salaries.Category
group by categories.category 


-------

select distinct product_id ,
FIRST_VALUE(new_price) over( partition by product_id order by change_date desc ) as price
from products 
where date(change_date) <=  date("2019-08-16")
union 
select product_id , 10 as price 
from products 
where product_id not in (select product_id from products where change_date <= date("2019-08-16"))

--------

with cte_numbers as (
select 
 num,
LAG(num) OVER ( ORDER BY id) AS num_anterior,
lead(num) OVER ( ORDER BY id) AS num_siguiente
from logs
)

select distinct(num) as ConsecutiveNums
from cte_numbers
where num = num_anterior and num = num_siguiente

---------


select Employees.employee_id , Employees.name , count(1) as reports_count ,round(avg(E2.age)) average_age 
from Employees inner join employees E2 
on Employees.employee_id =  E2.reports_to
group by 1 , 2
order by employees.employee_id asc



---------

select customer_id 
from 
customer 
inner join
product 
on customer.product_key = product.product_key
group by customer_id
having count(distinct(product.product_key)) = ( select count(distinct(product_key)) from product)

-----

select DATE_FORMAT(trans_date, '%Y-%m') AS month , country , count(id) as trans_count , 
sum(if(state = "approved" ,1,0)) as  approved_count, 
sum(amount) as trans_total_amount , sum(if(state= "approved",amount,0)) as approved_total_amount
from 
Transactions as t
group by month , country

------



SELECT w2.id
FROM Weather w1, Weather w2
WHERE DATEDIFF(w2.recordDate, w1.recordDate) = 1 AND w2.temperature > w1.temperature;

--------


