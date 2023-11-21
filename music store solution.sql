--   1. Who is the senior most employee based on job title?   
select * from employee
order by levels desc
limit 1
     
	 
-- 2. Which countries have the most Invoices?

 select count(billing_country) as count ,billing_country
 from invoice
 group by billing_country
 order by count desc
 limit 1
 
-- 3. What are top 3 values of total invoice?

select * from invoice
order by total desc
limit 3

/*  4. Which city has the best customers? We would like to throw a promotional Music 
    Festival in the city we made the most money. Write a query that returns one city that 
    has the highest sum of invoice totals. Return both the city name & sum of all invoice 
   totals */

select sum(total) as total , billing_country from invoice
group by billing_country
order by total desc
limit 1

/*  5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money */


select first_name,last_name,total from invoice 
join customer  on invoice.customer_id = customer.customer_id
order by total desc
limit 1


/*   6. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A */

select distinct first_name,last_name,email,genre.name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name like '%Rock%'
order by email 


/*   7. Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock band */



select  artist.name, count(album.artist_id) as total_no from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name like '%Rock%'
group by artist.name  order by  total_no desc limit 10

/*  8. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first */


select name, milliseconds from track
where  milliseconds >(
	select AVG(milliseconds) as time from track 
	)
order by milliseconds desc

/*  9.  Find how much amount spent by each customer on top most artist? Write a query to return
customer name, artist name and total spent by each customer on the artist */


with cte as (
	select artist.artist_id as artist_id ,
	artist.name As artist_name,
	sum(invoice_line.unit_price * invoice_line.quantity) as total_spent
	from invoice_line 
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	group by 1
	order by total_spent desc
	limit 1
	
)

select c.first_name, c.last_name ,sum(il.unit_price * il.quantity) as total_spent
from invoice i 
join customer c on i.customer_id =c.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album a on t.album_id = a.album_id
join cte on a.artist_id = cte.artist_id
group by 1,2
order by 3 desc

/*  10. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */
 

with cte as (
select  i.billing_country, count(il.quantity)as total, g.name ,
ROW_NUMBER() over (partition by i.billing_country order by count(il.quantity) desc ) as Rollno
from invoice_line il
join invoice i 
on il.invoice_id = i.invoice_id
join track t 
on il.track_id = t.track_id 
join genre g 
on  t.genre_id = g.genre_id
group by i.billing_country , g.name
)

select * from cte where rollno = 1




