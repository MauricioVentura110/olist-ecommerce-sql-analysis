-- 10. ¿Cuántos días tarda en promedio un pedido en entregarse?
select 
	avg(order_delivered_customer_date - order_delivered_carrier_date) as avg_delivery_time
from orders
where (order_purchase_timestamp is not null)
and (order_delivered_customer_date is not null)
and (order_delivered_carrier_date < order_delivered_customer_date);


-- 11. ¿Qué porcentaje de pedidos se entregó después de la fecha estimada?
-- ** Corregir numerador y denominador (sar case)
with late_deliveries as (
select 
	count(*) as count_late_deliveries
from orders
where (order_estimated_delivery_date is not null)
and (order_delivered_customer_date is not null)
and (order_estimated_delivery_date < order_delivered_customer_date)
), 
orders_delivered as (
select
	count(*) count_orders_delivered
from orders
where order_status = 'delivered'
)
select 
	round((ld.count_late_deliveries::numeric / od.count_orders_delivered) * 100, 2) as percentage_late_deliveries
from late_deliveries as ld, orders_delivered as od;
	
/*Variante más corta de la consulta anterior
SELECT
	ROUND(
	100.0 *
	COUNT(*) FILTER (
	    WHERE order_delivered_customer_date > order_estimated_delivery_date
	)
	/
	COUNT(*)
	,2) AS percentage_late_deliveries
FROM orders
WHERE order_status = 'delivered';
 */

