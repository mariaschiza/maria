
--let's access the Excel data imported 

Select *
FROM [Portfolio project]..PS

--change the type of all columns that contain financial/numerical information to real numbers with 2 decimal digits

ALTER TABLE [Portfolio project]..PS
ALTER COLUMN amount DECIMAL(20,2);

ALTER TABLE [Portfolio project]..PS
ALTER COLUMN oldbalanceOrg DECIMAL(20,2);

ALTER TABLE [Portfolio project]..PS
ALTER COLUMN newbalanceOrig DECIMAL(20,2);

ALTER TABLE [Portfolio project]..PS
ALTER COLUMN oldbalanceDest DECIMAL(20,2);

ALTER TABLE [Portfolio project]..PS
ALTER COLUMN newbalanceDest DECIMAL(20,2);


--check if there are any flagged fraud transactions. Flagged fraud transactions are single transactions of over 200,000 

SELECT *
FROM [Portfolio project]..PS
WHERE isFlaggedFraud = 1;

--the table is empty and therefore flagged fraud is never true 
--fraud transactions only exist when isFraud is true



--count the total number of fraud transactions

SELECT COUNT(*) AS total_fraudulent_transactions
FROM [Portfolio project]..PS
WHERE isFraud = 1;


-- the total and average amount of money legally transformed per method 

SELECT type, SUM(amount) AS total_amount, CAST(AVG(amount) AS DECIMAL(20,2)) AS average_amount
FROM [Portfolio project]..PS
WHERE isFraud=0
GROUP BY type
ORDER BY total_amount DESC;


--the total and average amount of money illegally transformed per method

SELECT type, SUM(amount) AS total_amount, CAST(AVG(amount) AS DECIMAL(20,2)) AS average_amount
FROM [Portfolio project]..PS
WHERE isFraud=1
GROUP BY type
ORDER BY total_amount DESC;

--we can see that fraud transactions were only made by Transfrer or Cash-out




--the number of negative balance accounts that are being shown as neutral in the table (newBalanceOrg=0.00)

SELECT COUNT(*) AS CountNegBalance
FROM [Portfolio project]..PS
WHERE oldbalanceOrg < amount
AND type IN ('TRANSFER', 'CASH_OUT', 'DEBIT', 'PAYMENT')
AND isFraud=0;




-- show the 5 highest amounts of money transitioned 
SELECT TOP 5 *
FROM [Portfolio project]..PS
ORDER BY amount DESC;

-- can see that only one transaction is legal, the remaining 80% is fraud


--In the website Kaggle that I got the data from, it was mentioned that all nameDest starting with M have null data entries in the columns new and old balance destinations

SELECT *
FROM [Portfolio project]..PS
WHERE nameDest NOT LIKE 'M%';

--create a new table that has all the information from all name destinations apart from those that start with the letter M

SELECT *
INTO [Portfolio project]..PSNotM 
FROM [Portfolio project]..PS
WHERE nameDest NOT LIKE 'M%';

--access the data from the new table

SELECT *
FROM [Portfolio project]..PSNotM 
