use sakila;

create view rental_summary as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, c.email,
COUNT(r.rental_id) as rental_count
from customer c
left join rental r on c.customer_id = r.customer_id
group by c.customer_id;

create temporary table payment_summary as
select rs.customer_id, sum(p.amount) as total_paid
from rental_summary rs
join payment p on rs.customer_id = p.customer_id
group by rs.customer_id;

with customer_summary as (select rs.customer_id, rs.customer_name, rs.email, rs.rental_count, ps.total_paid, ps.total_paid / rs.rental_count AS average_payment_per_rental
from rental_summary rs
join payment_summary ps on rs.customer_id = ps.customer_id)
select customer_name, email, rental_count, total_paid, average_payment_per_rental
from customer_summary;
