-- 5. ¿Qué clientes generan más ingresos (top 5)?
select
	o.customer_id,
	sum(oi.price + oi.freight_value) as total_revenue
from orders o
inner join order_items oi 
on o.order_id = oi.order_id
group by o.customer_id
order by sum(oi.price) desc
limit 5;


-- 6. ¿Cuántos clientes compraron más de una vez?
select
	count(*) as customers_with_multiple_orders
from (
select 
	customer_id
from orders
group by customer_id
having count(*) > 1);


-- 7. ¿Cuál es la distribución de pedidos por cliente (número de pedidos por cliente)?
with customer_orders as (
select 
	customer_id,
	count(*) total_purchases
from orders
group by customer_id
)
select
	total_purchases,
	count(*)
from customer_orders
group by total_purchases
order by total_purchases;

-- Extra: Segmentación de clientes
select 
	t.customer_id,
	t.total_spent,
	case
		when t.total_spent > 1000 then 'high value'
		when t.total_spent > 500 then 'medium value'
		else 'low value'
	end as customer_classification
from (
	select
		o.customer_id,
		sum(oi.price + oi.freight_value) total_spent
	from orders o
	inner join order_items oi 
	on o.order_id = oi.order_id
	group by o.customer_id
) as t;





