-- Q1: Last booked room
SELECT b.user_id, b.room_no
FROM bookings b
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = b.user_id
);

-- Q2: Billing in November
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11
  AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;

-- Q3: Bills > 1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- Q4: Item quantity per month
SELECT 
    MONTH(bc.bill_date) AS month,
    i.item_name,
    SUM(bc.item_quantity) AS total_quantity
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
GROUP BY MONTH(bc.bill_date), i.item_name;

-- Q5: Second highest bill (sorted)
SELECT 
    b.booking_id,
    b.user_id,
    MONTH(b.booking_date) AS month,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE YEAR(b.booking_date) = 2021
GROUP BY b.booking_id, b.user_id, MONTH(b.booking_date)
ORDER BY month, total_bill DESC;
