-- 1. ¿Cuál es el valor total de ventas generadas en la plataforma?
with cte as (
select 
	o.order_id,
	o.order_status,
	(oi.price + oi.freight_value) as total_line
from (orders o
inner join order_items oi 
on o.order_id = oi.order_id)
)
select 
	sum(total_line) as total_sales
from cte;


-- 2. ¿Cómo evolucionan las ventas mensualmente?
with monthly_sales as (
select 
    date_trunc('month', o.order_purchase_timestamp) as period,
    sum(oi.price + oi.freight_value) as sales
from orders o
join order_items oi 
on o.order_id = oi.order_id
group by period
)
select 
	cast(period as date),
	sales,
	sales - lag(sales, 1) over (order by period) as change_vs_previous_month,
	sum(sales) over (order by period) cumulative_sales
from monthly_sales;


-- 3. Cantidad de pedidos en cada estatus
select
	order_status as status,
	count(*) as total
from orders
group by status
order by status;


-- 4. ¿Cuánto gasta en promedio un cliente por pedido?
with customer_spending_per_order as (
select
	o.customer_id,
	o.order_id,
	sum(oi.price + oi.freight_value) as total_order
from orders o
inner join order_items oi
on o.order_id = oi.order_id
group by o.customer_id, o.order_id
)
select 
	round(avg(total_order), 2) as customer_avg_spent_per_order
from customer_spending_per_order;

