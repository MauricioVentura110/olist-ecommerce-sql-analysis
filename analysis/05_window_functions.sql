-- 12. ¿Cuál es el ranking de vendedores según ingresos?
select 
	t.seller_id,
	t.total_sold_per_seller,
	row_number() over (order by t.total_sold_per_seller desc),
	rank() over (order by t.total_sold_per_seller desc),
	dense_rank() over (order by t.total_sold_per_seller desc)
from (
	select
		s.seller_id,
		sum(oi.price + oi.freight_value) as total_sold_per_seller
	from order_items oi 
	inner join sellers s 
	on oi.seller_id = s.seller_id
	group by s.seller_id
) as t;


-- 13. Ranking de clientes por gasto
select 
	t.customer_id,
	t.customer_total_spent,
	dense_rank() over (order by t.customer_total_spent desc)
from (
select 
	o.customer_id,
	sum(oi.price + oi.freight_value) as customer_total_spent
from orders o 
inner join order_items oi 
on o.order_id = oi.order_id
group by o.customer_id
) as t;


-- 14. ¿Cómo crecen las ventas acumuladas en el tiempo?
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
	sum(sales) over (order by period
					rows between unbounded preceding and current row) cumulative_sales
from monthly_sales;


-- 15. ¿Cuál es el promedio de ventas de los últimos 3 meses?
with montly_sales as (
select 
	date_trunc('month', o.order_purchase_timestamp) as date_trunc_to_month,
	sum(oi.price + oi.freight_value) as sales
from orders o
inner join order_items oi 
on o.order_id = oi.order_id 
group by date_trunc_to_month
)
select 
	 ms.date_trunc_to_month as month,
	 ms.sales total_sales,
	 round(avg(ms.sales) over (order by date_trunc_to_month
						rows between 2 preceding and current row), 2)
						as avg_sales_last_3_months
from montly_sales as ms;


-- 16. ¿Cuánto tiempo pasa entre pedidos de un mismo cliente?
select
	o.customer_id,
	o.order_purchase_timestamp,
	lag(o.order_purchase_timestamp, 1) over (
	partition by o.customer_id 
	order by o.order_purchase_timestamp
	)as previous_order,
	o.order_purchase_timestamp 
	-
	lag(o.order_purchase_timestamp, 1) over (
	partition by o.customer_id 
	order by o.order_purchase_timestamp
	) as time_between_orders
from orders o
order by o.customer_id asc, o.order_purchase_timestamp asc;


-- 17. Primera compra de cada cliente
select distinct
	customer_id,
	first_value(order_purchase_timestamp) over (partition by customer_id 
						order by order_purchase_timestamp)
						as date_first_purchase,
	first_value(order_id) over (partition by customer_id 
						order by order_purchase_timestamp)
						as first_order
from orders
order by customer_id;


-- 18. Última compra de cada cliente (se usa "distinct on")
select distinct on (customer_id)
	customer_id,
	order_purchase_timestamp as date_last_purchase,
	order_id as last_orderc
from orders
order by customer_id, order_purchase_timestamp desc;







