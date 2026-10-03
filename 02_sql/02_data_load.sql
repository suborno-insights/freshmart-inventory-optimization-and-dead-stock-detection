/* =====================================================================
   RetailMart BD — Inventory Optimization & Dead Stock Detection
   02_data_load.sql

   Purpose: Load cleaned data from staging tables (imported via Excel)
            into the final Star Schema tables with correct data types.

   Prerequisite: Excel sheets imported into staging tables via
   SSMS Import Wizard:
     transactions       -> raw_transactions
     dim_product        -> dim_product_stage
     dim_supplier       -> dim_supplier_stage
     dim_warehouse       -> dim_warehouse_stage
   ===================================================================== */

USE RetailMart_BD;
GO

-- =====================================================================
-- 1. Populate dim_date (Jan 2023 - Dec 2024)
-- =====================================================================

WITH date_range AS (
    SELECT CAST('2023-01-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt)
    FROM date_range
    WHERE dt < '2024-12-31'
)
INSERT INTO dim_date
SELECT
    CAST(FORMAT(dt, 'yyyyMMdd') AS INT)    AS date_key,
    dt                                      AS full_date,
    DAY(dt)                                 AS day_of_month,
    DATENAME(WEEKDAY, dt)                   AS day_name,
    DATEPART(WEEK, dt)                      AS week_number,
    MONTH(dt)                               AS month_number,
    DATENAME(MONTH, dt)                     AS month_name,
    DATEPART(QUARTER, dt)                   AS quarter,
    YEAR(dt)                                AS year,
    CASE WHEN DATEPART(WEEKDAY, dt) IN (1,7) THEN 1 ELSE 0 END AS is_weekend
FROM date_range
OPTION (MAXRECURSION 1000);
GO

-- =====================================================================
-- 2. Populate dim_product
-- =====================================================================

INSERT INTO dim_product
SELECT
    TRIM(product_id),
    TRIM(product_name),
    TRIM(category),
    TRIM(sub_category),
    TRY_CAST(unit_cost AS DECIMAL(10,2)),
    TRY_CAST(unit_price AS DECIMAL(10,2)),
    TRY_CAST(reorder_level AS INT),
    TRY_CAST(min_stock_threshold AS INT),
    TRIM(supplier_id)
FROM dim_product_stage
WHERE product_id IS NOT NULL;
GO

-- =====================================================================
-- 3. Populate dim_supplier
-- =====================================================================

INSERT INTO dim_supplier
SELECT
    TRIM(supplier_id),
    TRIM(supplier_name),
    TRIM(country),
    TRY_CAST(lead_time_days AS TINYINT),
    TRY_CAST(reliability_score AS TINYINT)
FROM dim_supplier_stage
WHERE supplier_id IS NOT NULL;
GO

-- =====================================================================
-- 4. Populate dim_warehouse
-- =====================================================================

INSERT INTO dim_warehouse
SELECT
    TRIM(warehouse_id),
    TRIM(warehouse_name),
    TRIM(city),
    TRIM(region),
    TRY_CAST(storage_capacity_sqft AS INT)
FROM dim_warehouse_stage
WHERE warehouse_id IS NOT NULL;
GO

-- =====================================================================
-- 5. Populate fact_inventory_transactions
--    (Source: raw_transactions, cleaned in Excel prior to import)
-- =====================================================================

INSERT INTO fact_inventory_transactions
    (transaction_id, transaction_date, date_key, product_id, warehouse_id,
     supplier_id, transaction_type, quantity, unit_price, total_amount, data_issue)
SELECT
    TRIM(transaction_id),
    TRY_CAST(transaction_date AS DATE),
    CAST(FORMAT(TRY_CAST(transaction_date AS DATE), 'yyyyMMdd') AS INT),
    TRIM(product_id),
    TRIM(warehouse_id),
    NULLIF(TRIM(supplier_id), ''),
    TRIM(transaction_type),
    TRY_CAST(quantity AS INT),
    TRY_CAST(unit_price AS DECIMAL(10,2)),
    ABS(TRY_CAST(quantity AS INT)) * TRY_CAST(unit_price AS DECIMAL(10,2)),
    CASE WHEN quantity IS NULL THEN 1 ELSE 0 END
FROM raw_transactions
WHERE transaction_id IS NOT NULL
  AND TRY_CAST(transaction_date AS DATE) IS NOT NULL
  AND TRY_CAST(quantity AS INT) IS NOT NULL;
GO
