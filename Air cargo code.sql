use air_cargo;
#Q2
create table air_cargo.route_details(
route_id int not null,
flight_num varchar(10) check (flight_num LIKE 'FL-%'),
origin_airport varchar(25), destination_airport varchar(25),
aircraft_id varchar(25),
distance_miles decimal (10,2) CHECK (distance_miles >=0),
unique(route_id)
)
#Q3
SELECT customer_id FROM aircargo.passengers_on_flights 
where route_id >=01 or route_id <26;
#Q4
 select count (customer_id) as total_passangers,
 sum (price_per_ticket * no_of_tickets) as revenue
 from aircargo.ticket_details
 where class_id = 'Bussiness';
 
 #Q5 
 Select conact (frist_name, '',last_name) as full_name
 from aircargo.customer;
 
 #Q6
 select *
 from customer c
join ticket_details t on c.customer_id=
 t.customer_id ;

#Q7
 select distinct
 c.coustomer_id, c.first_name , c.last_name
 from aircargo.customer c
 inner join aircargo.ticket_details t on c.customer_id = t.customer_id
 where t.brand = 'Emirates';

#Q8
SELECT customer_id 
FROM passengers_on_flights
where class_id = 'Economy Plus'
GROUP BY customer_id
HAVING count(*) >0;

#Q9
SELECT IF (SUM(price_per_ticket* no_of_tickets) > 10000, 'Yes', 'NO') AS revenue_over_10000
FROM ticket_details;

#10
CREATE USER 'Arwaa_'@'localhost'
IDENTIFIED BY 'Ar111';
GRANT ALL PRIVILEGES ON air_cargo.* TO 'BsmahAb'@'localhost';
FLUSH PRIVILEGES; 

#11
SELECT distinct class_id,
MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_ticket_price
FROM ticket_details; 

#12
CREATE INDEX idx_routeID ON
passengers_on_flights(route_id);
SELECT * FROM air_cargo.passengers_on_flights 
WHERE route_id = 4;

#13
SELECT * 
FROM passengers_on_flights WHERE route_id = 4; 

#14
SELECT customer_id, aircraft_id, 
SUM(price_per_ticket * no_of_tickets) AS total_price
FROM ticket_details
GROUP BY customer_id, aircraft_id WITH ROLLUP;

#15 
CREATE VIEW Bussiness_class_customer AS
SELECT c.customer_id, c.first_name, c.last_name, t.brand
FROM ticket_details t
JOIN customer c ON t.customer_id = c.customer_id
WHERE t.class_id = 'Bussiness';

#16
DELIMITER //
CREATE PROCEDURE GetPassengerDetailsInRange(start_route INT, end_route INT)
BEGIN 
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'passenger_details')
THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Table passenger_details does not exist';
ELSE
SELECT *
FROM passenger_details
WHERE route_id BETWEEN start_route AND end_route;
END IF;
END //
DELIMITER ;

#17
DELIMITER //
CREATE PROCEDURE 
get_long_distance_routes()
BEGIN 
SELECT * FROM routes 
WHERE distance_miles > 2000;
END //
DELIMITER ;

#18
DELIMITER //
CREATE PROCEDURE
categorize_flight_distance()
BEGIN 
SELECT flight_num,
CASE 
WHEN distance_miles >= 0 AND
distance_miles <= 2000 THEN 'SDT'
WHEN distance_miles > 2000 AND
distance_miles <= 6500 THEN 'IDT'
ELSE 'LDT'
END AS distance_category
FROM routes;
END //
DELIMITER ;

#19
DELIMITER //
CREATE FUNCTION is_complimentary(class_id VARCHAR(50)) RETURNS VARCHAR(3)
deterministic
BEGIN
IF class_id = 'Bussiness' OR class_id = 'Economy Plus' THEN
RETURN 'Yes';
ELSE
RETURN 'No';
END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE 
get_ticket_details_with_complimentary()
BEGIN 
SELECT p_date, customer_id, class_id,
is_complimentary_services
FROM ticket_details;
END //
DELIMITER ;

#20 
DELIMITER //
CREATE PROCEDURE 
get_first_scott_customer()
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE first_name, last_name VARCHAR(50);
DECLARE cur CURSOR FOR 
SELECT first_name, last_name
FROM customer 
WHERE last_name LIKE '%Scott';
DECLARE CONTINUE HANDLER FOR NOT FOUND 
SET done = TRUE;
OPEN cur;
FETCH cur INTO first_name, last_name;
IF NOT done THEN
SELECT first_name, last_name;
ELSE
SELECT 'No customer found' AS message;
END IF;
CLOSE cur;
END //
DELIMITER ;
