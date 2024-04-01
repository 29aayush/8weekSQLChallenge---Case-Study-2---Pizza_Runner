use pizza_runner;

## PIZZA METRICS 


# How many pizzas were ordered?
select count(order_id) as pizza_ordered from customer_orders;

# How many unique customer orders were made?
select count(distinct customer_id) as unique_customer_count from customer_orders;

# How many successful orders were delivered by each runner?
select runner_id,count(distinct order_id) as orders_delivered_count from runner_orders
where duration is not null
group by runner_id;

# How many of each type of pizza was delivered?
select pizza_id,count(pizza_id) as pizza_delivered from customer_orders c
join runner_orders r on c.order_id=r.order_id
where duration is not null
group by pizza_id;

# How many Vegetarian and Meatlovers were ordered by each customer?
select p.pizza_name,count(c.pizza_id) as pizza_delivered from customer_orders c
join pizza_names p on c.pizza_id=p.pizza_id
group by p.pizza_name;

# What was the maximum number of pizzas delivered in a single order?
select pizza_cnt as maximum_pizzas_delivered_in_single_order from (
select order_id,count(pizza_id) as pizza_cnt,dense_rank() over (order by count(pizza_id) desc) as rnk  from customer_orders
group by order_id )a
where a.rnk=1;

# For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select c.customer_id,sum(case when exclusions is null and extras is null then 1 else 0 end )as pizza_with_no_changes,
sum(case when exclusions is not null or extras is not null then 1 else 0 end) as pizza_with_changes
from customer_orders c
join runner_orders r on c.order_id=r.order_id
where duration is not null
group by c.customer_id;

# How many pizzas were delivered that had both exclusions and extras?

select count(c.order_id) as pizzas_with_exclusions_and_extras from customer_orders c
join runner_orders r on c.order_id=r.order_id
where duration is not null and  (exclusions is not null and extras is not null);

# What was the total volume of pizzas ordered for each hour of the day?

select hour(order_time) as hour_of_the_day,count(order_id) as volume from customer_orders
group by hour(order_time);

# What was the volume of orders for each day of the week?
select dayofweek(order_time) as day_of_the_week,count(order_id) as volume from customer_orders
group by dayofweek(order_time);


