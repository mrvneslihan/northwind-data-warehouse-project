/*
-------------------------------------------------------------------------------
DDL Script: Create Gold Views
-------------------------------------------------------------------------------
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
-------------------------------------------------------------------------------
*/


-- Create Dimension: gold.fact_orders

IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    o.employee_id,
    o.order_date,
    o.required_date,
    o.shipped_date,  
    o.ship_name,
    o.ship_city,
    o.ship_subregion,
    o.ship_country,
    od.product_id,
    od.unit_price,
    od.quantity,
    od.discount,
    s.shipper_id,
    s.company_name AS shipper_company_name

FROM silver.orders o
LEFT JOIN silver.order_details od
    ON o.order_id = od.order_id
LEFT JOIN silver.shippers s
    ON o.ship_via = s.shipper_id;
GO


-- Create Dimension: gold.dim_products

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key, -- Surrogate key
    p.product_id,
    p.product_name,
    p.supplier_id,
    p.category_id,
    p.quantity_per_unit,
    p.unit_price,
    p.units_in_stock,
    p.units_on_order,    
    p.reorder_level,
    p.discontinued,
    c.category_name

FROM silver.products p
LEFT JOIN silver.categories c
    ON p.category_id = c.category_id
GO


-- Create Dimension: gold.dim_customers

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key, -- Surrogate key
    customer_id,
    company_name,
    contact_name,
    contact_title,
    city,
    subregion,
    country,
    phone

FROM silver.customers
GO

-- Create Dimension: gold.dim_employees

IF OBJECT_ID('gold.dim_employees', 'V') IS NOT NULL
    DROP VIEW gold.dim_employees;
GO

CREATE VIEW gold.dim_employees AS
SELECT
    ROW_NUMBER() OVER (ORDER BY e.employee_id) AS employee_key, -- Surrogate key
    e.employee_id,
    e.last_name,
    e.first_name,
    e.title,
    e.title_of_courtesy,
    e.birth_date,
    e.hire_date,
    e.city,
    e.subregion,
    e.country,
    e.reports_to,
    et.territory_id,
    t.region_id,
    r.region_description AS region_name

FROM silver.employees e
LEFT JOIN silver.employee_territories et
    ON e.employee_id = et.employee_id
LEFT JOIN silver.territories t
    ON et.territory_id = t.territory_id
LEFT JOIN silver.regions r
    ON t.region_id = r.region_id
GO

-- Create Dimension: gold.dim_suppliers

IF OBJECT_ID('gold.dim_suppliers', 'V') IS NOT NULL
    DROP VIEW gold.dim_shippers;
GO

CREATE VIEW gold.dim_suppliers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY supplier_id) AS supplier_key, -- Surrogate key
    supplier_id,
    company_name,
    contact_name,
    contact_title,    
    city,
    subregion,
    country

FROM silver.suppliers
GO