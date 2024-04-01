use pizza_runner;

update customer_orders
set exclusions=null
where exclusions="" or exclusions="null";

update customer_orders
set extras=null
where extras="" or extras="null";

update runner_orders
set pickup_time=null
where pickup_time="" or pickup_time="null";

update runner_orders
set distance=null
where distance="" or distance="null";

update runner_orders
set duration=null
where duration="" or duration="null";

update runner_orders
set cancellation=null
where cancellation="" or cancellation="null";




