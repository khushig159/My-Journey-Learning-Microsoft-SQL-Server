--SELECT * FROM persons

--ALTER TABLE persons
--ADD email VARCHAR(50) NOT NULL

--DROP COLUMN phone

--DROP TABLE persons



--INSERT INTO customers(id,first_name,country,score)
--VALUES
--	(6,'Khushi','India',NULL),
---	(7,'Sam',NULL,100)
--SELECT * FROM customers

--Insert data from customer to persons

--TRUNCATE TABLE persons

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers

SELECT * FROM persons