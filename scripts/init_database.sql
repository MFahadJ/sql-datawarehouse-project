/*

====================================
               Create DB and Schemas
=====================================
Script Purpose:
Createion of new Database DataWareHouse after checking if it is not already exist if exist then first drop and make the new one  
after that create the new schemas :
1) Bronze
2) Silver
3) GOLD

Warning:
Runing this script drop the entire database it is already present so it means all the records deleted. Ensure that you have the proper backuo



*/





USE master;
GO

IF EXISTS(select 1 from sys.database where name = 'DataWarehouse')
BEGIN
  Alter Database DatWarehouse  Set Single_User WITH ROLLBACK IMMEDIATE;
DROP Database DataWarehouse;
END;
GO

--Create Data warehouse Projects
  
CREATE DATABASE DataWarehouse;
GO
  
USE DataWarehouse;

CREATE Schema bronze;
GO
CREATE Schema silver;
GO
CREATE Schema gold;



