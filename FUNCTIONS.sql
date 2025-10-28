SELECT 
TRIM(UPPER(first_name)),LEN(TRIM(first_name)) AS Length_of_firstname,LOWER(country),CONCAT(first_name,' ',country) AS name_country FROM customers

SELECT '523-111-321-333' AS phone,
REPLACE('523-111-321-333','-','') AS clean_phone

SELECT first_name,
LEFT(TRIM(first_name),2) AS firsttwochar,
RIGHT(TRIM(first_name),2) AS lasttwochar,
SUBSTRING(TRIM(first_name),2,4) AS subchar
FROM customers

SELECT 3.516 AS original,
ROUND(3.516,2) AS rounded

SELECT -3.516 AS original,
ABS(-3.516) AS rounded

