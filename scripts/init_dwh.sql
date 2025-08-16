/*
-------------------------------------------------------------
Create Database and Schemas
-------------------------------------------------------------
Purpose:
    Creates the 'NorthwindDWH' database. If it exists, it will be dropped 
    and recreated, then three schemas ('bronze', 'silver', 'gold') will be added.

Note:
    This process permanently deletes all existing data. 
    Back up the database before running.
*/


USE master;
GO

-- Drop and recreate the 'NorthwindDWH' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'NorthwindDWH')
BEGIN
    ALTER DATABASE NorthwindDWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NorthwindDWH;
END;
GO

-- Create the 'NorthwindDWH' database
CREATE DATABASE NorthwindDWH;
GO

USE NorthwindDWH;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO