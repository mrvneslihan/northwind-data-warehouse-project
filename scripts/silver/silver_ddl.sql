
/*
-------------------------------------------------------------------------------
DDL Script: Create Silver Tables
-------------------------------------------------------------------------------
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	Run this script to re-define the DDL structure of 'silver' Tables
-------------------------------------------------------------------------------
*/


IF OBJECT_ID('silver.categories', 'U') IS NOT NULL
    DROP TABLE silver.categories;
GO

CREATE TABLE silver.categories (
    category_id         INT NOT NULL,
    category_name       NVARCHAR(15) NOT NULL,
    description         NTEXT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.customers', 'U') IS NOT NULL
    DROP TABLE silver.customers;
GO

CREATE TABLE silver.customers (
    customer_id        NCHAR(5) NOT NULL,
    company_name       NVARCHAR(40) NOT NULL,
    contact_name       NVARCHAR(30),
    contact_title      NVARCHAR(30),
    address            NVARCHAR(60),
    city               NVARCHAR(15),
    subregion          NVARCHAR(25),
    postal_code        NVARCHAR(10),
    country            NVARCHAR(15),
    phone              NVARCHAR(24),
    fax                NVARCHAR(24),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.employees', 'U') IS NOT NULL
    DROP TABLE silver.employees;
GO

CREATE TABLE silver.employees (
    employee_id        INT NOT NULL,
    last_name          NVARCHAR(20) NOT NULL,
    first_name         NVARCHAR(20) NOT NULL,
    title              NVARCHAR(30),
    title_of_courtesy  NVARCHAR(25),
    birth_date         DATE,
    hire_date          DATE,
    address            NVARCHAR(60),    
    city               NVARCHAR(15),
    subregion          NVARCHAR(25),
    postal_code        NVARCHAR(10),
    country            NVARCHAR(15),
    home_phone         NVARCHAR(24),
    notes              NTEXT,
    reports_to         INT,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.employee_territories', 'U') IS NOT NULL
    DROP TABLE silver.employee_territories;
GO

CREATE TABLE silver.employee_territories (
    employee_id        INT NOT NULL,
    territory_id       NVARCHAR(20) NOT NULL,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.order_details', 'U') IS NOT NULL
    DROP TABLE silver.order_details;
GO

CREATE TABLE silver.order_details (
    order_id           INT NOT NULL,
    product_id         INT NOT NULL,
    unit_price         MONEY NOT NULL,
    quantity           SMALLINT NOT NULL,
    discount           REAL NOT NULL,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.orders', 'U') IS NOT NULL
    DROP TABLE silver.orders;
GO

CREATE TABLE silver.orders (
    order_id         INT NOT NULL,
    customer_id      NCHAR(5),
    employee_id      INT,
    order_date       DATE,
    required_date    DATE,
    shipped_date     DATE,
    ship_via         INT,
    freight          MONEY,    
    ship_name        NVARCHAR(40),
    ship_address     NVARCHAR(60),
    ship_city        NVARCHAR(15),
    ship_subregion   NVARCHAR(25),
    ship_postal_code NVARCHAR(10),
    ship_country     NVARCHAR(15),
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.products', 'U') IS NOT NULL
    DROP TABLE silver.products;
GO

CREATE TABLE silver.products (
    product_id        INT NOT NULL,
    product_name      NVARCHAR(40) NOT NULL,
    supplier_id       INT,
    category_id       INT,
    quantity_per_unit NVARCHAR(20),
    unit_price        MONEY,
    units_in_stock    SMALLINT,
    units_on_order    SMALLINT,    
    reorder_level     SMALLINT,
    discontinued      BIT NOT NULL,
    dwh_create_date   DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.regions', 'U') IS NOT NULL
    DROP TABLE silver.regions;
GO

CREATE TABLE silver.regions (
    region_id          INT NOT NULL,
    region_description NCHAR(50) NOT NULL,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.shippers', 'U') IS NOT NULL
    DROP TABLE silver.shippers;
GO

CREATE TABLE silver.shippers (
    shipper_id         INT NOT NULL,
    company_name       NVARCHAR(40) NOT NULL,
    phone              NVARCHAR(24),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.suppliers', 'U') IS NOT NULL
    DROP TABLE silver.suppliers;
GO

CREATE TABLE silver.suppliers (
    supplier_id       INT NOT NULL,
    company_name       NVARCHAR(40) NOT NULL,
    contact_name       NVARCHAR(30),
    contact_title      NVARCHAR(30),
    address            NVARCHAR(60),    
    city               NVARCHAR(15),
    subregion          NVARCHAR(25),
    postal_code        NVARCHAR(10),
    country            NVARCHAR(15),
    phone              NVARCHAR(24),
    fax                NVARCHAR(24),
    home_page          NTEXT,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.territories', 'U') IS NOT NULL
    DROP TABLE silver.territories;
GO

CREATE TABLE silver.territories (
    territory_id          NVARCHAR(20) NOT NULL,
    territory_description NCHAR(50) NOT NULL,
    region_id             INT NOT NULL,
    dwh_create_date       DATETIME2 DEFAULT GETDATE()
);
GO