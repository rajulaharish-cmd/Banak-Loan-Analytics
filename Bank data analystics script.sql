Create database bank_data_analytics;
use bank_data_analytics;
Create table bank_data (Account_ID varchar(50),
                        Min_age int,
                        max_age int,
                        bh_name varchar(100),
                        Bank_Name varchar(100),
                        branch_name varchar(100),
                        Caste varchar(100),
                        Center_Id int,
                        City varchar(50),
                        Client_id int,
                        Client_Name varchar(100),
                        Close_Client varchar(50),
                        Closed_Date datetime,
                        Credif_Officer_Name varchar(100),
                        DOB date,
                        Disbursed_By varchar(100),
                        Disbursed_date date,
                        Disbursed_year varchar(100),
                        gender enum ('Male','Female'),
                        home_ownership varchar(100),
                        Loan_Status varchar(100),
                        Loan_Transferdate varchar(10),
                        NextMeetingDate date,
                        Product_Code varchar(50),
                        Grade varchar(10),
                        Sub_Grade varchar(10),
                        Product_Id varchar(20),
                        Purpose_Category varchar(20),
                        Region_Name varchar(20),
                        Religion varchar(20),
                        Verification_Status varchar(20),
                        State_Abbr varchar(20),
                        State_Name varchar(20),
                        Tranfer_Logic varchar(20),
                        Is_Delinquent_Loan varchar(10),
                        Is_Default_Loan varchar(10),
                        Age_T int,
                        Delinq_2_Yrs int,
                        Application_Type varchar(10),
                        Loan_Amount decimal(12,2),
                        Funded_Amount decimal(12,2),
                        Funded_Amount_Inv decimal(12,2),
                        Term varchar(20),
                        Int_Rate decimal(10,2),
                        Total_Pymnt decimal(12,2),
                        Total_Pymnt_inv decimal(12,2),
                        Total_Rec_Prncp decimal(12,2),
                        Total_Fees decimal(10,2),
                        Total_Rrec_int decimal(10,2),
                        Total_Rec_Late_fee decimal(10,2),
                        Recoveries decimal(10,2),
                        Collection_Recovery_fee decimal(10,2));                

SET SQL_SAFE_UPDATES = 0;                        
update bank_data set Religion ='others' where Religion= '';

SET GLOBAL local_infile = 1;

alter table bank_data add age_range varchar(20);

update bank_data set age_range = concat(Min_age,'-',max_age);

LOAD DATA LOCAL INFILE 'C:/Harish/Harish Excelr/Project/Bank project/Data/CSV/Bank Data Analystics csv.csv'
INTO TABLE bank_data
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from bank_data;

-- 1 Total Loan Amount
select concat("₹",round(sum(Funded_Amount),2)) as 'total_loan_amt' from bank_data;

-- No of loan issues
select count(loan_amount) as 'no_of_loan_issued' from bank_data;

--  Interest

select sum(Total_Rrec_int) as total_interest from bank_data;

-- Age wise burrowers

SELECT 
    CASE 
        WHEN min_age >= 18 AND max_age <= 25 THEN '18-25'
        when min_age >= 26 and max_age <= 35 THEN '26-35'
        when min_age >= 36 and max_age <=45 then  '36-45'
        when min_age >= 45 and max_age <60 then '46-59'
        ELSE '60+'
    END AS age_group, count(loan_amount) as 'loan_borrowed'
FROM bank_data
group by age_group
order by count(loan_amount) desc;

-- Branch-Wise Performance Ranking:
select branch_name, 
CONCAT("₹",sum(Total_Rec_Prncp)
 + sum(Total_Fees) 
 + sum(Total_Rrec_int)) as revenue, dense_rank() over (order by CONCAT("₹",sum(Total_Rec_Prncp)
 + sum(Total_Fees) 
 + sum(Total_Rrec_int)) desc) as 'rank'
from bank_data
group by branch_name;



--- BOTTOM 10 BRANCH PERFORMANCE
select branch_name, 
CONCAT("₹",sum(Total_Rec_Prncp)
 + sum(Total_Fees) 
 + sum(Total_Rrec_int)) as revenue
from bank_data
group by branch_name
order by revenue ASC
LIMIT 10;

-- Religion-Wise Loan
 SELECT Religion, COUNT(Loan_Amount) AS Loan_borrowed
 from bank_data
 where religion is not null
 GROUP BY Religion
 order by Loan_borrowed desc;
 
 -- Product Group-Wise Loan
 select Purpose_Category as Loan_category, 
 concat("₹", COUNT(Loan_Amount)) AS Loan_borrowed
 from bank_data
 GROUP BY Purpose_Category
 order by COUNT(Loan_Amount) desc;
 
 --- Grade-Wise Loan

 select Grade,COUNT(Loan_Amount) AS Loan_borrowed
 from bank_data
 where grade <> ''
 group by Grade
 order by Loan_borrowed desc;

--- Delinquent Client Count: Tracks borrowers with missed payments.
-- name of the borrowers missed payment

select Client_Name,Is_Delinquent_Loan as missed_payment
from bank_data where Is_Delinquent_Loan="y";

-- No of borrowers missed payment
select count(Client_Name) as borrowers,Is_Delinquent_Loan as 'missed_payments'
from bank_data where Is_Delinquent_Loan="y"
group by missed_payments;

--- Default Loan Count:
 select count(Is_Default_Loan) as loan_deafult
 from bank_data
 where Is_Default_Loan="y";
 


---  Identifies loans without proper verification.

select count(Client_Name) as client,Verification_Status
from bank_data
where Verification_Status = 'Not Verified' 
group by Verification_Status;

select Client_Name as client,Verification_Status
from bank_data
where Verification_Status = 'Not Verified';

select * from bank_data; 
SELECT VERSION();
