-- 8. ¿Qué vendedores generan más ventas (top 5)?
select 
	s.seller_id,
	sum(oi.price + oi.freight_value) as total_sold
from order_items oi 
inner join sellers s 
on oi.seller_id = s.seller_id
group by s.seller_id
order by total_sold desc
limit 5;


-- 9. ¿Qué vendedores venden más volumen de productos (top 5 vendedores)?
select 
	s.seller_id,
	count(*) as total_volume_sold
from order_items oi 
inner join sellers s 
on oi.seller_id = s.seller_id
group by s.seller_id
order by total_volume_sold desc
limit 5;


