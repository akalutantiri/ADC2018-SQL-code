
/*
Single Table for implementation of Inhertance from SuperClass 'Staff'

Sample JSON Strings for SubClasses:
	DECLARE   @Instore  NVARCHAR(200) = N'{"SubClass" : "InStore" ,  "HourlyRate" : 25.50}'
	DECLARE   @Driver   NVARCHAR(200)  = N'{"SubClass" : "Driver", "DeliveryRate": 5.50, "licNo" : "x7890"}'

Advantages:
	Adding a new SubClass is easy, extensive code changes not needed
	Just by altering 2 constrains a major model change can be accomodated.
	SubClass attributes can be added/deleted without changing table structures or loss of data

	*/

DROP TABLE IF EXISTS Staff_Eg1;  --New in SQL Server 2016
go

CREATE TABLE Staff_Eg1 (                 
	id			INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Need an auto incremented PK
	staffId		NCHAR(4) ,                         -- Not the PK but can be inedxed
	firstName 	NVARCHAR(50),
	lastName	NVARCHAR(50),
	status		NVARCHAR(10) DEFAULT 'Active',
	subClass	AS	JSON_VALUE( jData, '$.SubClass') PERSISTED, --Extracting a key value from JSON string
	jData		NVARCHAR(4000)

	CONSTRAINT IsValidJSON_I CHECK (ISJSON(jData) = 1),
)

go


INSERT  Staff_Eg1 (staffId, firstName, lastName, jdata)
VALUES 
('0001', 'Joe', 'De Silva', N'{"SubClass" : "Driver", "DeliveryRate": 5.50, "licNo" : "x7890"}'),
('0004', 'Bill', 'Clinton', N'{"SubClass" : "Driver", "DeliveryRate": 5.50, "licNo" : "y5890"}'),
('0005', 'Jil', 'Wang', N'{"SubClass" : "Driver", "DeliveryRate": 5.50, "licNo" : "x2390"}'),
('0008', 'Deepa', 'Vidana', N'{"SubClass" : "Driver", "DeliveryRate": 5.50, "licNo" : "x3401"}'),
('0003', 'Mark', 'Ip', N'{"SubClass" : "Driver", "DeliveryRate": 6.50, "licNo" : "x5680"}'),
('0002', 'Brian', 'Kumar', N'{"SubClass" : "InStore" ,  "HourlyRate" : 25.50}'),
('0012', 'Tim', 'Ng', N'{"SubClass" : "InStore" ,  "HourlyRate" : 25.50}'),
('0021', 'Ron', 'Moshito', N'{"SubClass" : "InStore" ,  "HourlyRate" : 12}'),
('0024', 'Tim', 'Vlad', N'{"SubClass" : "InStore" ,  "HourlyRate" : 29.00}')

  
-- For (Optional/Mandatory, Disjoint) 
ALTER TABLE Staff_Eg1 Add Constraint U_Staff UNIQUE (staffId);  --For Optional /Mandatory
ALTER TABLE Staff_Eg1 ADD CONSTRAINT Notnull_subClass CHECK(subClass is NOT NULL);  --Mandatory
