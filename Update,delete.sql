SELECT *
FROM customers

UPDATE customers
SET score=0
WHERE id=6

UPDATE customers
SET score=0, country='UK'
WHERE id=7

UPDATE customers
SET score=0
WHERE score IS NULL

DELETE FROM customers
WHERE score < 10

SELECT * FROM customers