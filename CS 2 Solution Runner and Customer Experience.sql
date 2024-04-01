use pizza_runner;

#How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

#What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select distinct r.runner_id,avg(abs((TIMESTAMPDIFF(minute,r.pickup_time,c.order_time)))) from runner_orders r join customer_orders c on c.order_id=r.order_id
where cancellation is  null
group by r.runner_id;

#Is there any relationship between the number of pizzas and how long the order takes to prepare?
select c.order_id,count(pizza_id),avg(abs((TIMESTAMPDIFF(minute,r.pickup_time,c.order_time))))  from customer_orders c 
join runner_orders r on  c.order_id=r.order_id
group by order_id
order by count(pizza_id) desc;

#What was the average distance travelled for each customer?
select customer_id,round(avg(distance),2) from customer_orders c 
join runner_orders r on  c.order_id=r.order_id
group by customer_id;

#What was the difference between the longest and shortest delivery times for all orders?
select max(abs(TIMESTAMPDIFF(minute,r.pickup_time,c.order_time))) -min(abs(TIMESTAMPDIFF(minute,r.pickup_time,c.order_time))) as diff_delivery_time from customer_orders c 
join runner_orders r on  c.order_id=r.order_id;

#What was the average speed for each runner for each delivery and do you notice any trend for these values?
select c.order_id,sum(distance) as distance,sum(abs(TIMESTAMPDIFF(minute,r.pickup_time,c.order_time))) as time, 
sum(distance)/sum(abs(TIMESTAMPDIFF(minute,r.pickup_time,c.order_time))) as avg_speed_kmpmin from customer_orders c 
join runner_orders r on  c.order_id=r.order_id
where cancellation is null
group by c.order_id;

#What is the successful delivery percentage for each runner?
with cte1 as (select distinct r.runner_id,sum(case when cancellation is  null then 1 else 0 end )as complete_delivery,
sum(case when cancellation is not null then 1 else 0 end) as incomplete_delivery from customer_orders c 
join runner_orders r on  c.order_id=r.order_id
group by r.runner_id)

select runner_id,round((complete_delivery/(complete_delivery+incomplete_delivery))*100,2) from cte1
group by runner_id;