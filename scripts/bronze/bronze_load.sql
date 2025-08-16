/*
-------------------------------------------------------------------------------
Stored Procedure: Load bronze Layer (Source -> bronze)
-------------------------------------------------------------------------------
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from another datawarehouse 'northwind'. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `INSERT INTO` command to load data.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading bronze Layer';
		PRINT '================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.categories';
		TRUNCATE TABLE NorthwindDWH.bronze.categories;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.categories';
		
		INSERT INTO NorthwindDWH.bronze.categories (
		   category_id,
           category_name,
           description )
	    SELECT
		   CategoryID,
		   CategoryName,
		   Description
		FROM northwind.dbo.Categories;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.customers';
		TRUNCATE TABLE NorthwindDWH.bronze.customers;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.customers';

		INSERT INTO NorthwindDWH.bronze.customers (
           customer_id,
           company_name,
           contact_name,
           contact_title,
           address,
           city,
           region,
           postal_code,
           country,
           phone,
           fax )
		SELECT 
		   CustomerID,
           CompanyName,
           ContactName,
           ContactTitle,
           Address,
           City,
           Region,
           PostalCode,
           Country,
           Phone,
           Fax
		FROM northwind.dbo.Customers;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.employees';
		TRUNCATE TABLE NorthwindDWH.bronze.employees;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.employees';

		INSERT INTO NorthwindDWH.bronze.employees (
           employee_id,
           last_name,
           first_name,
           title,
           title_of_courtesy,
           birth_date,
           hire_date,
           address,    
           city,
           region,
		   postal_code,
		   country,
		   home_phone,
		   notes,
		   reports_to )
		SELECT
		   EmployeeID,
           LastName,
           FirstName,
           Title,
		   TitleOfCourtesy,
		   BirthDate,
		   HireDate,
           Address,
           City,
           Region,
           PostalCode,
           Country,
           HomePhone,
		   Notes,
           ReportsTo
		FROM northwind.dbo.Employees;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.employee_territories';
		TRUNCATE TABLE NorthwindDWH.bronze.employee_territories;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.employee_territories';

		INSERT INTO NorthwindDWH.bronze.employee_territories(
		   employee_id,
           territory_id )
	    SELECT
		   EmployeeID,
		   TerritoryID
		FROM northwind.dbo.EmployeeTerritories;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.order_details';
		TRUNCATE TABLE NorthwindDWH.bronze.order_details;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.order_details';

		INSERT INTO NorthwindDWH.bronze.order_details (
		   order_id,
		   product_id,
		   unit_price,
		   quantity,
           discount )
	    SELECT
		   OrderID,
		   ProductID,
		   UnitPrice,
		   Quantity,
		   Discount
		FROM northwind.dbo.[Order Details];

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.orders';
		TRUNCATE TABLE NorthwindDWH.bronze.orders;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.orders';

		INSERT INTO NorthwindDWH.bronze.orders (
		   order_id,
		   customer_id,
		   employee_id,
		   order_date,
		   required_date,
		   shipped_date,
	       ship_via,
		   freight,    
		   ship_name,
		   ship_address,
		   ship_city,
		   ship_region,
		   ship_postal_code,
		   ship_country )
	    SELECT
		   OrderID,
		   CustomerID,
		   EmployeeID,
		   OrderDate,
		   RequiredDate,
		   ShippedDate,
	       ShipVia,
		   Freight,    
		   ShipName,
		   ShipAddress,
		   ShipCity,
		   ShipRegion,
		   ShipPostalCode,
		   ShipCountry
		FROM northwind.dbo.Orders;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.products';
		TRUNCATE TABLE NorthwindDWH.bronze.products;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.products';

		INSERT INTO NorthwindDWH.bronze.products (
		   product_id,
		   product_name,
		   supplier_id,
		   category_id,
		   quantity_per_unit,
		   unit_price,
		   units_in_stock,
		   units_on_order,    
		   reorder_level,
		   discontinued )
	    SELECT
		   ProductID,
		   ProductName,
		   SupplierID,
		   CategoryID,
		   QuantityPerUnit,
		   UnitPrice,
		   UnitsInStock,
		   UnitsOnOrder,    
		   ReorderLevel,
		   Discontinued
		FROM northwind.dbo.Products;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.regions';
		TRUNCATE TABLE NorthwindDWH.bronze.regions;
		PRINT '>> Inserting Data Into: NorthwindDWH.regions';

		INSERT INTO NorthwindDWH.bronze.regions (
           region_id,
           region_description )
	    SELECT
		   RegionID,
		   RegionDescription
		FROM northwind.dbo.Region;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.shippers';
		TRUNCATE TABLE NorthwindDWH.bronze.shippers;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.shippers';

		INSERT INTO NorthwindDWH.bronze.shippers (
           shipper_id,
           company_name,
           phone )
	    SELECT
           ShipperID,
           CompanyName,
           Phone
		FROM northwind.dbo.Shippers;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.suppliers';
		TRUNCATE TABLE NorthwindDWH.bronze.suppliers;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.suppliers';

		INSERT INTO NorthwindDWH.bronze.suppliers (
		   suppliers_id,
		   company_name,
		   contact_name,
		   contact_title,
		   address,    
		   city,
		   region,
		   postal_code,
		   country,
		   phone,
		   fax,
		   home_page )
	    SELECT
		   SupplierID,
		   CompanyName,
		   ContactName,
		   ContactTitle,
		   Address,
           City,
           Region,
           PostalCode,
           Country,
           Phone,
		   Fax,
		   HomePage
		FROM northwind.dbo.Suppliers;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

				SET @start_time = GETDATE();
		PRINT '>> Truncating Table: NorthwindDWH.bronze.territories';
		TRUNCATE TABLE NorthwindDWH.bronze.territories;
		PRINT '>> Inserting Data Into: NorthwindDWH.bronze.territories';

		INSERT INTO NorthwindDWH.bronze.territories (
           territory_id,
           territory_description,
           region_id )
	    SELECT
		   TerritoryID,
           TerritoryDescription,
           RegionID 
		FROM northwind.dbo.Territories;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING bronze LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END