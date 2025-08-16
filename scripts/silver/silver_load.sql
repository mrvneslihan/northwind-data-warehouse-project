/*
-------------------------------------------------------------------------------
Stored Procedure: Load silver Layer (Bronze -> silver)
-------------------------------------------------------------------------------
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading silver Layer';
		PRINT '================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.categories';
		TRUNCATE TABLE silver.categories;
		PRINT '>> Inserting Data Into: silver.categories';
		
		INSERT INTO silver.categories (
		   category_id,
           category_name,
           description )
	    SELECT
		   category_id,
           category_name,
           description
		FROM bronze.categories;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.customers';
		TRUNCATE TABLE silver.customers;
		PRINT '>> Inserting Data Into: silver.customers';

		INSERT INTO silver.customers (
           customer_id,
           company_name,
           contact_name,
           contact_title,
           address,
           city,
           subregion,
           postal_code,
           country,
           phone,
           fax )
		SELECT 
		   customer_id,
           company_name,
           contact_name,
           contact_title,
           address,
           city,
           CASE
		      WHEN region IS NULL THEN 'n/a'
		      WHEN region = 'AK' THEN 'Alaska'
		      WHEN region = 'BC' THEN 'British Columbia'
		      WHEN region = 'CA' THEN 'California'
		      WHEN region = 'Co. Cork' THEN 'County Cork'
		      WHEN region = 'DF' THEN 'Distrito Federal'
		      WHEN region = 'ID' THEN 'Idaho'
		      WHEN region = 'MT' THEN 'Montana'
		      WHEN region = 'NM' THEN 'New Mexico'
		      WHEN region = 'OR' THEN 'Oregon'
		      WHEN region = 'RJ' THEN 'Rio de Janeiro'
		      WHEN region = 'SP' THEN 'São Paulo'
		      WHEN region = 'WA' THEN 'Washington'
		      WHEN region = 'WY' THEN 'Wyoming'
		      ELSE region
           END AS subregion,
           ISNULL(postal_code,'n/a') AS postal_code,
           country,
           phone,
           ISNULL(fax,'n/a') AS fax 
		FROM bronze.customers;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.employees';
		TRUNCATE TABLE silver.employees;
		PRINT '>> Inserting Data Into: silver.employees';

		INSERT INTO silver.employees (
           employee_id,
           last_name,
           first_name,
           title,
           title_of_courtesy,
           birth_date,
           hire_date,
           address,    
           city,
           subregion,
		   postal_code,
		   country,
		   home_phone,
		   notes,
		   reports_to )
		SELECT
           employee_id,
           last_name,
           first_name,
           title,
           title_of_courtesy,
           CAST(birth_date AS DATE) AS birth_date,
           CAST(hire_date AS DATE) AS hire_date,
           address,    
           city,
           CASE
		      WHEN region IS NULL THEN 'n/a'
		      WHEN region = 'WA' THEN 'Washington'
			  ELSE region
		   END AS subregion,
		   postal_code,
		   country,
		   home_phone,
		   notes,
		   ISNULL(reports_to, 0) AS reports_to
		FROM bronze.employees;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.employee_territories';
		TRUNCATE TABLE silver.employee_territories;
		PRINT '>> Inserting Data Into: silver.employee_territories';

		INSERT INTO silver.employee_territories (
		   employee_id,
           territory_id )
	    SELECT
		   employee_id,
           territory_id
		FROM bronze.employee_territories;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.order_details';
		TRUNCATE TABLE silver.order_details;
		PRINT '>> Inserting Data Into: silver.order_details';

		INSERT INTO silver.order_details (
		   order_id,
		   product_id,
		   unit_price,
		   quantity,
           discount )
	    SELECT
		   order_id,
		   product_id,
		   unit_price,
		   quantity,
           discount
		FROM bronze.order_details;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.orders';
		TRUNCATE TABLE silver.orders;
		PRINT '>> Inserting Data Into: silver.orders';

		INSERT INTO silver.orders (
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
		   ship_subregion,
		   ship_postal_code,
		   ship_country )
	    SELECT
		   order_id,
		   customer_id,
		   employee_id,
		   CAST(order_date AS DATE) AS order_date,
		   CAST(required_date AS DATE) AS required_date,
           CAST(ISNULL(shipped_date, '9999-12-31') AS DATE) AS shipped_date,
	       ship_via,
		   freight,    
		   ship_name,
		   ship_address,
		   ship_city,
		   CASE
		      WHEN ship_region IS NULL THEN 'n/a'
		      WHEN ship_region = 'AK' THEN 'Alaska'
		      WHEN ship_region = 'BC' THEN 'British Columbia'
		      WHEN ship_region = 'CA' THEN 'California'
		      WHEN ship_region = 'Co. Cork' THEN 'County Cork'
		      WHEN ship_region = 'DF' THEN 'Distrito Federal'
		      WHEN ship_region = 'ID' THEN 'Idaho'
		      WHEN ship_region = 'MT' THEN 'Montana'
		      WHEN ship_region = 'NM' THEN 'New Mexico'
		      WHEN ship_region = 'OR' THEN 'Oregon'
		      WHEN ship_region = 'RJ' THEN 'Rio de Janeiro'
		      WHEN ship_region = 'SP' THEN 'São Paulo'
		      WHEN ship_region = 'WA' THEN 'Washington'
		      WHEN ship_region = 'WY' THEN 'Wyoming'
		      ELSE ship_region
           END AS ship_subregion,
		   ISNULL(ship_postal_code, 'n/a') AS ship_postal_code,
		   ship_country   
		FROM bronze.orders;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.products';
		TRUNCATE TABLE silver.products;
		PRINT '>> Inserting Data Into: silver.products';

		INSERT INTO silver.products (
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
		   product_id,
		   product_name,
		   supplier_id,
		   category_id,
		   quantity_per_unit,
		   unit_price,
		   units_in_stock,
		   units_on_order,    
		   reorder_level,
		   discontinued
		FROM bronze.products;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.regions';
		TRUNCATE TABLE silver.regions;
		PRINT '>> Inserting Data Into: regions';

		INSERT INTO silver.regions (
           region_id,
           region_description )
	    SELECT
		   region_id,
           region_description
		FROM bronze.regions;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.shippers';
		TRUNCATE TABLE silver.shippers;
		PRINT '>> Inserting Data Into: silver.shippers';

		INSERT INTO silver.shippers (
           shipper_id,
           company_name,
           phone )
	    SELECT
           shipper_id,
           company_name,
           phone 
		FROM bronze.shippers;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.suppliers';
		TRUNCATE TABLE silver.suppliers;
		PRINT '>> Inserting Data Into: silver.suppliers';

		INSERT INTO silver.suppliers (
		   supplier_id,
		   company_name,
		   contact_name,
		   contact_title,
		   address,    
		   city,
		   subregion,
		   postal_code,
		   country,
		   phone,
		   fax,
		   home_page )
	    SELECT
		   suppliers_id AS supplier_id,
		   company_name,
		   contact_name,
		   contact_title,
		   address,    
		   city,
		   CASE
		      WHEN region IS NULL THEN 'n/a'
		      WHEN region = 'AK' THEN 'Alaska'
		      WHEN region = 'BC' THEN 'British Columbia'
		      WHEN region = 'CA' THEN 'California'
		      WHEN region = 'Co. Cork' THEN 'County Cork'
		      WHEN region = 'DF' THEN 'Distrito Federal'
		      WHEN region = 'ID' THEN 'Idaho'
		      WHEN region = 'MT' THEN 'Montana'
		      WHEN region = 'NM' THEN 'New Mexico'
		      WHEN region = 'OR' THEN 'Oregon'
		      WHEN region = 'RJ' THEN 'Rio de Janeiro'
		      WHEN region = 'SP' THEN 'São Paulo'
		      WHEN region = 'WA' THEN 'Washington'
		      WHEN region = 'WY' THEN 'Wyoming'
		      ELSE region
           END AS subregion,
		   postal_code,
		   country,
		   phone,
		   ISNULL(fax, 'n/a') AS fax,
		   ISNULL(home_page, 'n/a') AS home_page
		FROM bronze.suppliers;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

				SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.territories';
		TRUNCATE TABLE silver.territories;
		PRINT '>> Inserting Data Into: silver.territories';

		INSERT INTO silver.territories (
           territory_id,
           territory_description,
           region_id )
	    SELECT
		   territory_id,
           territory_description,
           region_id 
		FROM bronze.territories;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING silver LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END