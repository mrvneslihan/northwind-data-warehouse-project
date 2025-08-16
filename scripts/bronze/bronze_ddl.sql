
/*
-------------------------------------------------------------------------------
DDL Script: Create Bronze Tables
-------------------------------------------------------------------------------
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables
-------------------------------------------------------------------------------
*/


IF OBJECT_ID('bronze.categories', 'U') IS NOT NULL
    DROP TABLE bronze.categories;
GO

CREATE TABLE bronze.categories (
    category_id         INT NOT NULL,
    category_name       NVARCHAR(15) NOT NULL,
    description         NTEXT
);
GO

IF OBJECT_ID('bronze.customers', 'U') IS NOT NULL
    DROP TABLE bronze.customers;
GO

CREATE TABLE bronze.customers (
    customer_id        NCHAR(5) NOT NULL,
    company_name       NVARCHAR(40) NOT NULL,
    contact_name       NVARCHAR(30),
    contact_title      NVARCHAR(30),
    address            NVARCHAR(60),
    city               NVARCHAR(15),
    region             NVARCHAR(15),
    postal_code        NVARCHAR(10),
    country            NVARCHAR(15),
    phone              NVARCHAR(24),
    fax                NVARCHAR(24)
);
GO

IF OBJECT_ID('bronze.employees', 'U') IS NOT NULL
    DROP TABLE bronze.employees;
GO

CREATE TABLE bronze.employees (
    employee_id        INT NOT NULL,
    last_name          NVARCHAR(20) NOT NULL,
    first_name         NVARCHAR(20) NOT NULL,
    title              NVARCHAR(30),
    title_of_courtesy  NVARCHAR(25),
    birth_date         DATETIME,
    hire_date          DATETIME,
    address            NVARCHAR(60),    
    city               NVARCHAR(15),
    region             NVARCHAR(15),
    postal_code        NVARCHAR(10),
    country            NVARCHAR(15),
    home_phone         NVARCHAR(24),
    notes              NTEXT,
    reports_to         INT
);
GO

IF OBJECT_ID('employee_territories', 'U') IS NOT NULL
    DROP TABLE employee_territories;
GO

CREATE TABLE bronze.employee_territories (
    employee_id        INT NOT NULL,
    territory_id       NVARCHAR(20) NOT NULL,
);
GO

IF OBJECT_ID('bronze.order_details', 'U') IS NOT NULL
    DROP TABLE bronze.order_details;
GO

CREATE TABLE bronze.order_details (
    order_id           INT NOT NULL,
    product_id         INT NOT NULL,
    unit_price         MONEY NOT NULL,
    quantity           SMALLINT NOT NULL,
    discount           REAL NOT NULL
);
GO

IF OBJECT_ID('bronze.orders', 'U') IS NOT NULL
    DROP TABLE bronze.orders;
GO

CREATE TABLE bronze.orders (
    order_id         INT NOT NULL,
    customer_id      NCHAR(5),
    employee_id      INT,
    order_date       DATETIME,
    required_date    DATETIME,
    shipped_date     DATETIME,
    ship_via         INT,
    freight          MONEY,    
    ship_name        NVARCHAR(40),
    ship_address     NVARCHAR(60),
    ship_city        NVARCHAR(15),
    ship_region      NVARCHAR(15),
    ship_postal_code NVARCHAR(10),
    ship_country     NVARCHAR(15)
);
GO

IF OBJECT_ID('bronze.products', 'U') IS NOT NULL
    DROP TABLE bronze.products;
GO

CREATE TABLE bronze.products (
    product_id        INT NOT NULL,
    product_name      NVARCHAR(40) NOT NULL,
    supplier_id       INT,
    category_id       INT,
    quantity_per_unit NVARCHAR(20),
    unit_price        MONEY,
    units_in_stock    SMALLINT,
    units_on_order    SMALLINT,    
    reorder_level     SMALLINT,
    discontinued      BIT NOT NULL
);
GO

IF OBJECT_ID('bronze.regions', 'U') IS NOT NULL
    DROP TABLE bronze.regions;
GO

CREATE TABLE bronze.regions (
    region_id          INT NOT NULL,
    region_description NCHAR(50) NOT NULL
);
GO

IF OBJECT_ID('bronze.shippers', 'U') IS NOT NULL
    DROP TABLE bronze.shippers;
GO

CREATE TABLE bronze.shippers (
    shipper_id         INT NOT NULL,
    company_name       NVARCHAR(40) NOT NULL,
    phone              NVARCHAR(24)
);
GO

IF OBJECT_ID('bronze.suppliers', 'U') IS NOT NULL
    DROP TABLE bronze.suppliers;
GO

CREATE TABLE bronze.suppliers (
    suppliers_id       INT NOT NULL,
    company_name       NVARCHAR(40) NOT NULL,
    contact_name       NVARCHAR(30),
    contact_title      NVARCHAR(30),
    address            NVARCHAR(60),    
    city               NVARCHAR(15),
    region             NVARCHAR(15),
    postal_code        NVARCHAR(10),
    country            NVARCHAR(15),
    phone              NVARCHAR(24),
    fax                NVARCHAR(24),
    home_page          NTEXT
);
GO

IF OBJECT_ID('bronze.territories', 'U') IS NOT NULL
    DROP TABLE bronze.territories;
GO

CREATE TABLE bronze.territories (
    territory_id          NVARCHAR(20) NOT NULL,
    territory_description NCHAR(50) NOT NULL,
    region_id             INT NOT NULL
);
GO