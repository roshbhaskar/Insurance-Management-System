use insurance;

CREATE TABLE agent (
  Agent_code varchar(10) NOT NULL,
  Agent_name varchar(150) NOT NULL,
  DOB date NOT NULL,
  Address varchar(80) NOT NULL,
  Pincode int(6) NOT NULL,
  Branch varchar(50) NOT NULL,
  Contact_Num bigint(10) NOT NULL CHECK (Contact_Num LIKE '9%' AND Contact_Num < 9999999999),
  Super_code varchar(10) DEFAULT NULL
);

CREATE TABLE customer (
  Customer_Num bigint(10) NOT NULL,
  First_Name varchar(50) NOT NULL,
  Last_Name varchar(50) NOT NULL,
  Gender char(1) NOT NULL CHECK( Gender = 'M' OR Gender = 'F'),
  DOB date NOT NULL,
  Address varchar(70) NOT NULL,
  Pincode int(6) NOT NULL,
  Contact_Number bigint(10) NOT NULL CHECK (Contact_Number LIKE '9%' AND Contact_Number < 9999999999),
  Mother_Name varchar(150) NOT NULL,
  Father_Name varchar(150) NOT NULL,
  Marital_status char(1) NOT NULL CHECK( Marital_status = 'S' OR Marital_status='M'),
  Spouse_Name varchar(150) DEFAULT NULL
);

CREATE TABLE policy (
  Policy_Num int(15) NOT NULL,
  Customer_Num bigint(10) NOT NULL,
  Agent_code varchar(10) NOT NULL,
  DOC date NOT NULL,
  Product varchar(50) NOT NULL,
  Sum_Assured int(10) NOT NULL,
  Pay_Period int(2) NOT NULL,
  Ins_Period int(2) NOT NULL
);

CREATE TABLE premium (
  Policy_Num int(15) NOT NULL,
  Premium int(10) NOT NULL,
  Mode varchar(3) NOT NULL,
  Last_date date NOT NULL CHECK (CAST(Last_date as date) <= CAST(GETDATE() as date))
  );

CREATE TABLE unpaid_premium (
  Policy_Num int(15) NOT NULL,
  Fine int(10) NOT NULL,
  Delayed_days int(11) NOT NULL
);

CREATE TABLE paid_premium (
  Receipt_Num int(23) NOT NULL,
  Receipt_Date date NOT NULL,
  Policy_Num int(15) NOT NULL
); 

#primary key
ALTER TABLE agent
  ADD PRIMARY KEY (Agent_code);
  
ALTER TABLE customer
  ADD PRIMARY KEY (Customer_Num);

ALTER TABLE policy
  ADD PRIMARY KEY (Policy_Num),
  ADD KEY Agent_code (Agent_code),
  ADD KEY Customer_Num (Customer_Num);

ALTER TABLE premium
  ADD PRIMARY KEY (Policy_Num);


ALTER TABLE unpaid_premium
  ADD PRIMARY KEY (Policy_Num);

ALTER TABLE paid_premium
  ADD PRIMARY KEY (Receipt_Num),
  ADD KEY Policy_Num (Policy_Num);

#adding foreign keys
ALTER TABLE paid_premium
  ADD CONSTRAINT Policy_Num FOREIGN KEY (Policy_Num) REFERENCES premium (Policy_Num) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE policy
  ADD CONSTRAINT Agent_code FOREIGN KEY (Agent_code) REFERENCES agent (Agent_code) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT Customer_Num FOREIGN KEY (Customer_Num) REFERENCES customer (Customer_Num) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE premium
  ADD CONSTRAINT Policy FOREIGN KEY (Policy_Num) REFERENCES policy (Policy_Num) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE unpaid_premium
  ADD CONSTRAINT Policy_Unpaid FOREIGN KEY (Policy_Num) REFERENCES premium (Policy_Num) ON DELETE CASCADE ON UPDATE CASCADE;

#EXPLAIN FUNCTINAL DEPENDENCIES
# forgot check 

ALTER TABLE agent 
ADD CONSTRAINT Agents_agent
CHECK (Agent_Code != Super_Code);


# triggers
CREATE TRIGGER droptherows
AFTER DELETE 
ON customer 
FOR EACH ROW 
DELETE FROM policy
WHERE policy.Customer_Number= OLD.Customer_Num ;

CREATE TRIGGER droptherows1
AFTER DELETE 
ON policy 
FOR EACH ROW 
DELETE FROM premium
WHERE premium.Policy_Num= OLD.Policy_Num ;

CREATE TRIGGER droptherows2
AFTER DELETE 
ON premium 
FOR EACH ROW 
DELETE FROM paid_premium
WHERE paid_premium.Policy_Num= OLD.Policy_Num ;

#inserting values
#agent
INSERT INTO agent (`Agent_code`, `Agent_name`, `DOB`, `Address`, `Pincode`, `Branch`, `Contact_Num`, `Super_Code`) VALUES
('234abc231', 'Sanjay', '1966-02-21', '21/694, Satyam Apartment, Refinery Road, Gorwa', 390016, 'Vadodara', 7016636683,'177DEF177');

INSERT IGNORE INTO agent (`Agent_code`, `Agent_name`, `DOB`, `Address`, `Pincode`, `Branch`, `Contact_Num`,`Super_Code`) VALUES
('177DEF177', 'Vasudha', '1999-08-02', '144/694, Patel Apartment, Kudlu Road, Blore', 560100, 'Bangalore', 9116636683,null);

INSERT INTO agent (`Agent_code`, `Agent_name`, `DOB`, `Address`, `Pincode`, `Branch`, `Contact_Num`,`Super_Code`) VALUES
('100ZPQ101', 'Anoushka', '2000-06-20', '12/623, Sun City Apartment, Sarjapur Road, Blore', 560123, 'Bangalore', 9116634321,null);


INSERT INTO agent (`Agent_code`, `Agent_name`, `DOB`, `Address`, `Pincode`, `Branch`, `Contact_Num`,`Super_Code`) VALUES
('101ZPQ101', 'Sonali', '2000-06-06', '12/623, Trinity Apartment, Sarjapur Road, Blore', 560123, 'Bangalore', 9232334321,null);

#customer
INSERT INTO `customer` (`Customer_Num`, `First_Name`, `Last_Name`, `Gender`, `DOB`, `Address`, `Pincode`, `Contact_Number`, `Mother_Name`, `Father_Name`,  `Marital_status`, `Spouse_Name`) VALUES
(10002, 'Devam', 'Sheth', 'M', '2018-10-02', '21/694, Satyam Apartment, Refinery Road, Gorwa', 390016, 7016636683, 'Harsha Sheth', 'Sanjay Sheth', 'S', '');

INSERT INTO `customer` (`Customer_Num`, `First_Name`, `Last_Name`, `Gender`, `DOB`, `Address`, `Pincode`, `Contact_Number`, `Mother_Name`, `Father_Name`,  `Marital_status`, `Spouse_Name`) VALUES
(10177, 'Vasudha', 'Sarathy', 'F', '1999-08-02', '144/694, Patel Apartment, Kudlu Road, Blore', 560100, 9116636683, 'Uma Sarathy', 'Partha Sarathy', 'M', 'Timothee Chalamet');

INSERT INTO `customer` (`Customer_Num`, `First_Name`, `Last_Name`, `Gender`, `DOB`, `Address`, `Pincode`, `Contact_Number`, `Mother_Name`, `Father_Name`,  `Marital_status`, `Spouse_Name`) VALUES
(10252, 'Shrey', 'Sarkar', 'F', '2000-03-31', '1/611, Sunshine Apartment, Madiwala Road, Blore', 560068, 9116121233, 'Lily Sarkar', 'Vinod Sarkar', 'M', 'Matthew Daddario');

#policy
INSERT INTO `policy` (`Policy_Num`, `Customer_Num`, `Agent_code`, `DOC`, `Product`, `Sum_Assured`, `Pay_Period`, `Ins_Period`) VALUES
(123564789, 10002, '234abc231', '2018-10-02', 'Jeevan Labh', 35000, 5, 10),
(284049583, 10177, '100ZPQ101', '2007-06-20', 'Jeevan Lakshya', 450000, 35, 80);

INSERT INTO `policy` (`Policy_Num`, `Customer_Num`, `Agent_code`, `DOC`, `Product`, `Sum_Assured`, `Pay_Period`, `Ins_Period`) VALUES
(284040001, 10252, '101ZPQ101', '2007-06-22', 'Jeevan Lakshya', 450000, 35, 80);
#premium
INSERT INTO `premium` (`Policy_Num`, `Premium`, `Mode`, `Last_date`) VALUES
(123564789, 3500, 'YLY', '2018-12-01'),
(284049583, 469, 'MLY', '2018-12-01');

INSERT INTO `premium` (`Policy_Num`, `Premium`, `Mode`, `Last_date`) VALUES
(284040001, 400, 'MLY', '2018-12-01');

#upaid_premium
INSERT INTO `unpaid_premium` (`Policy_Num`, `Fine`, `Delayed_days`) VALUES
(123564789, 0, 0),
(284049583, 0, 0);

INSERT INTO `unpaid_premium` (`Policy_Num`, `Fine`, `Delayed_days`) VALUES
(284040001, 100, 8);
#paid_premium
INSERT INTO `paid_premium` (`Receipt_Num`, `Receipt_Date`, `Policy_Num`) VALUES
(325256815, '2018-10-31', 123564789),
(325284137, '2018-11-01', 284049583),
(325289940, '2018-11-01', 123564789);


#QUERIES

# Select Names of all the customers who havent paid the premium and their fine
 SELECT First_Name , Fine
 FROM customer,policy,unpaid_premium
 WHERE customer.Customer_Num = policy.Customer_Num AND policy.Policy_Num = unpaid_premium.Policy_Num AND 
 unpaid_premium.Fine > 0
 AND EXISTS(SELECT Product FROM customer,unpaid_premium,policy 
 WHERE customer.Customer_Num = policy.Customer_Num AND policy.Policy_Num=unpaid_premium.Policy_Num);
 
 
 #  Names of all the customers who have taken Jeevan Lakshya Policy and have no fine
SELECT DISTINCT First_Name
FROM agent ,customer,unpaid_premium,policy
WHERE Product IN (
SELECT Product FROM agent, policy WHERE Product='Jeevan Lakshya' 
AND policy.Customer_Num = customer.Customer_Num)
AND Fine IN ( SELECT Fine FROM unpaid_premium,customer,policy 
WHERE customer.Customer_Num = policy.Customer_Num AND
 policy.Policy_Num=unpaid_premium.Policy_Num AND Fine=0);

# Select the Super Agents and Agents
#outer join 
SELECT E.Agent_Name , S.Agent_Name
FROM agent as E RIGHT OUTER JOIN agent as S ON E.Agent_Code = S.Super_Code ;

#Max sum assured in the jeevan Lashya policy
#aggregate
SELECT MAX(Sum_Assured)
FROM ( customer JOIN policy ON customer.Customer_Num = policy.Customer_Num)
WHERE ( Product ='Jeevan Lakshya');


# Selecting the branches with branches count more than 2
SELECT DISTINCT Branch
FROM agent
WHERE Branch IN (
SELECT Branch
FROM agent 
GROUP BY Branch HAVING COUNT(*) > 2);


DELETE FROM customer 
WHERE Customer_Num = 10002 ;

