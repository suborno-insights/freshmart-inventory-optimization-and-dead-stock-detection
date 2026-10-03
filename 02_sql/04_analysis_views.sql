/* =====================================================================
   RetailMart BD — Inventory Optimization & Dead Stock Detection
   04_analysis_views.sql

   Purpose: Create the 8 analytical views that power the Power BI
            dashboard. All views exclude flagged rows (data_issue = 0)
            unless otherwise noted.
   ===================================================================== */

USE RetailMart_BD;
GO

-- =====================================================================
-- VIEW 1: ABC Analysis
-- Classifies products by revenue contribution (A = top 70%,
-- B = next 20%, C = bottom 10%)
-- =====================================================================

CREATE VIEW vw_abc_analysis AS
WITH product_revenue AS (
    SELECT
        f.product_id,
        p.product_name,
        p.category,
        SUM(ABS(f.quantity) * f.unit_price) AS total_revenue
    FROM fact_inventory_transactions f
    JOIN dim_product p ON f.product_id = p.product_id
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
    GROUP BY f.product_id, p.product_name, p.category
),
ranked_revenue AS (
    SELECT
        *,
        SUM(total_revenue) OVER () AS grand_total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS running_total,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM product_revenue
)
SELECT
    revenue_rank,
    product_id,
    product_name,
    category,
    total_revenue,
    ROUND(total_revenue * 100.0 / grand_total_revenue, 2) AS revenue_pct,
    ROUND(running_total * 100.0 / grand_total_revenue, 2) AS cumulative_pct,
    CASE
        WHEN running_total * 100.0 / grand_total_revenue <= 70 THEN 'A'
        WHEN running_total * 100.0 / grand_total_revenue <= 90 THEN 'B'
        ELSE 'C'
    END AS abc_category
FROM ranked_revenue;
GO

-- =====================================================================
-- VIEW 2: XYZ Analysis
-- Classifies products by demand volatility using Coefficient of
-- Variation (CV) over a COMPLETE 24-month grid (missing months = 0
-- sales, not excluded -- critical for correctly identifying dead stock)
-- =====================================================================

CREATE VIEW vw_xyz_analysis AS
WITH all_months AS (
    SELECT DISTINCT year, month_number
    FROM dim_date
    WHERE full_date BETWEEN '2023-01-01' AND '2024-12-31'
),
all_product_months AS (
    SELECT
        p.product_id,
        m.year,
        m.month_number
    FROM dim_product p
    CROSS JOIN all_months m
),
actual_monthly_sales AS (
    SELECT
        f.product_id,
        YEAR(f.transaction_date)  AS sale_year,
        MONTH(f.transaction_date) AS sale_month,
        SUM(ABS(f.quantity))      AS monthly_qty
    FROM fact_inventory_transactions f
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
    GROUP BY f.product_id, YEAR(f.transaction_date), MONTH(f.transaction_date)
),
complete_monthly_sales AS (
    SELECT
        apm.product_id,
        apm.year,
        apm.month_number,
        COALESCE(ams.monthly_qty, 0) AS monthly_qty
    FROM all_product_months apm
    LEFT JOIN actual_monthly_sales ams
        ON apm.product_id = ams.product_id
       AND apm.year = ams.sale_year
       AND apm.month_number = ams.sale_month
),
product_stats AS (
    SELECT
        product_id,
        AVG(monthly_qty * 1.0)   AS avg_monthly_sales,
        STDEV(monthly_qty * 1.0) AS stdev_monthly_sales,
        COUNT(*)                 AS total_months,
        SUM(CASE WHEN monthly_qty = 0 THEN 1 ELSE 0 END) AS zero_sale_months
    FROM complete_monthly_sales
    GROUP BY product_id
)
SELECT
    p.product_id,
    pr.product_name,
    p.avg_monthly_sales,
    p.stdev_monthly_sales,
    p.total_months,
    p.zero_sale_months,
    ROUND(
        CASE WHEN p.avg_monthly_sales = 0 THEN 999
             ELSE (p.stdev_monthly_sales / p.avg_monthly_sales) * 100
        END, 2
    ) AS coefficient_of_variation,
    CASE
        WHEN p.avg_monthly_sales = 0 THEN 'Z'
        WHEN (p.stdev_monthly_sales / p.avg_monthly_sales) * 100 <= 20 THEN 'X'
        WHEN (p.stdev_monthly_sales / p.avg_monthly_sales) * 100 <= 50 THEN 'Y'
        ELSE 'Z'
    END AS xyz_category
FROM product_stats p
JOIN dim_product pr ON p.product_id = pr.product_id;
GO

-- =====================================================================
-- VIEW 3: ABC-XYZ Combined Matrix
-- Joins ABC and XYZ into a single 9-segment classification
-- (e.g., AX, AY, ..., CZ)
-- =====================================================================

CREATE VIEW vw_abc_xyz_matrix AS
SELECT
    a.product_id,
    a.product_name,
    a.category,
    a.total_revenue,
    a.revenue_pct,
    a.abc_category,
    x.avg_monthly_sales,
    x.coefficient_of_variation,
    x.zero_sale_months,
    x.xyz_category,
    a.abc_category + x.xyz_category AS combined_segment
FROM vw_abc_analysis a
JOIN vw_xyz_analysis x ON a.product_id = x.product_id;
GO

-- =====================================================================
-- VIEW 4: Stock Aging Analysis
-- Calculates days since last sale and current tied-up capital,
-- per product-warehouse combination
-- =====================================================================

CREATE VIEW vw_stock_aging AS
WITH last_sale AS (
    SELECT
        product_id,
        warehouse_id,
        MAX(transaction_date) AS last_sale_date
    FROM fact_inventory_transactions
    WHERE transaction_type = 'Sale'
      AND data_issue = 0
    GROUP BY product_id, warehouse_id
),
current_stock AS (
    SELECT
        product_id,
        warehouse_id,
        stock_balance,
        ROW_NUMBER() OVER (
            PARTITION BY product_id, warehouse_id
            ORDER BY transaction_date DESC, transaction_id DESC
        ) AS rn
    FROM fact_inventory_transactions
    WHERE data_issue = 0
)
SELECT
    cs.product_id,
    p.product_name,
    p.category,
    cs.warehouse_id,
    w.warehouse_name,
    cs.stock_balance AS current_stock,
    p.unit_cost,
    ROUND(cs.stock_balance * p.unit_cost, 2) AS tied_up_capital,
    ls.last_sale_date,
    DATEDIFF(DAY, ls.last_sale_date, '2024-12-31') AS days_since_last_sale,
    CASE
        WHEN ls.last_sale_date IS NULL THEN 'Never Sold'
        WHEN DATEDIFF(DAY, ls.last_sale_date, '2024-12-31') <= 30 THEN 'Active'
        WHEN DATEDIFF(DAY, ls.last_sale_date, '2024-12-31') <= 60 THEN 'Slow Moving'
        WHEN DATEDIFF(DAY, ls.last_sale_date, '2024-12-31') <= 90 THEN 'At Risk'
        ELSE 'Dead Stock'
    END AS aging_bucket
FROM current_stock cs
JOIN dim_product p ON cs.product_id = p.product_id
JOIN dim_warehouse w ON cs.warehouse_id = w.warehouse_id
LEFT JOIN last_sale ls
    ON cs.product_id = ls.product_id
   AND cs.warehouse_id = ls.warehouse_id
WHERE cs.rn = 1;
GO

-- =====================================================================
-- VIEW 5: Reorder Point Analysis
-- avg_daily_sales is calculated over the FULL 730-day period
-- (not just active-selling days) -- critical for accurate reorder
-- points on slow/dead-moving products
-- =====================================================================

CREATE VIEW vw_reorder_analysis AS
WITH sales_totals AS (
    SELECT
        f.product_id,
        SUM(ABS(f.quantity)) AS total_qty_sold
    FROM fact_inventory_transactions f
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
    GROUP BY f.product_id
),
daily_variability AS (
    SELECT
        f.product_id,
        f.transaction_date,
        SUM(ABS(f.quantity)) AS daily_qty
    FROM fact_inventory_transactions f
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
    GROUP BY f.product_id, f.transaction_date
),
all_days AS (
    SELECT DISTINCT full_date FROM dim_date WHERE full_date BETWEEN '2023-01-01' AND '2024-12-31'
),
complete_daily AS (
    SELECT
        p.product_id,
        d.full_date,
        COALESCE(dv.daily_qty, 0) AS daily_qty
    FROM dim_product p
    CROSS JOIN all_days d
    LEFT JOIN daily_variability dv
        ON p.product_id = dv.product_id AND d.full_date = dv.transaction_date
),
daily_sales_stats AS (
    SELECT
        product_id,
        AVG(daily_qty * 1.0)   AS avg_daily_sales,
        STDEV(daily_qty * 1.0) AS stdev_daily_sales
    FROM complete_daily
    GROUP BY product_id
),
current_stock_company AS (
    SELECT
        product_id,
        SUM(current_stock) AS total_current_stock
    FROM vw_stock_aging
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    p.category,
    s.supplier_name,
    s.lead_time_days,
    ROUND(d.avg_daily_sales, 3)   AS avg_daily_sales,
    ROUND(d.stdev_daily_sales, 3) AS stdev_daily_sales,
    ROUND(d.avg_daily_sales * s.lead_time_days, 1) AS lead_time_demand,
    -- Safety stock uses a Z-score of 1.65 (95% service level)
    ROUND(1.65 * d.stdev_daily_sales * SQRT(s.lead_time_days), 1) AS safety_stock,
    ROUND(
        (d.avg_daily_sales * s.lead_time_days) +
        (1.65 * d.stdev_daily_sales * SQRT(s.lead_time_days))
    , 0) AS reorder_point,
    c.total_current_stock,
    p.reorder_level AS existing_reorder_level_in_master,
    CASE
        WHEN c.total_current_stock <= ROUND(
            (d.avg_daily_sales * s.lead_time_days) +
            (1.65 * d.stdev_daily_sales * SQRT(s.lead_time_days))
        , 0) THEN 'Reorder Now'
        ELSE 'Sufficient Stock'
    END AS reorder_status
FROM daily_sales_stats d
JOIN dim_product p ON d.product_id = p.product_id
JOIN dim_supplier s ON p.supplier_id = s.supplier_id
JOIN current_stock_company c ON d.product_id = c.product_id;
GO

-- =====================================================================
-- VIEW 6: Inventory Turnover Ratio
-- Uses RECENT 6-month COGS (annualized) rather than full 24-month
-- COGS, so dead stock products correctly show near-zero turnover
-- instead of being masked by historical (pre-dead) sales activity
-- =====================================================================

CREATE VIEW vw_inventory_turnover AS
WITH cogs_recent AS (
    SELECT
        f.product_id,
        SUM(ABS(f.quantity) * p.unit_cost) AS recent_cogs
    FROM fact_inventory_transactions f
    JOIN dim_product p ON f.product_id = p.product_id
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
      AND f.transaction_date >= '2024-07-01'
    GROUP BY f.product_id
),
cogs_full AS (
    SELECT
        f.product_id,
        SUM(ABS(f.quantity) * p.unit_cost) AS total_cogs_24mo
    FROM fact_inventory_transactions f
    JOIN dim_product p ON f.product_id = p.product_id
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
    GROUP BY f.product_id
),
avg_inventory AS (
    SELECT
        product_id,
        SUM(current_stock) AS total_current_stock,
        SUM(tied_up_capital) AS current_inventory_value
    FROM vw_stock_aging
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COALESCE(cr.recent_cogs, 0) AS recent_6mo_cogs,
    cf.total_cogs_24mo,
    a.current_inventory_value,
    ROUND(
        CASE WHEN a.current_inventory_value = 0 THEN 0
             ELSE (COALESCE(cr.recent_cogs, 0) * 2) / a.current_inventory_value
        END
    , 2) AS annualized_turnover_ratio,
    ROUND(
        CASE WHEN COALESCE(cr.recent_cogs, 0) = 0 THEN 999
             ELSE 365.0 / ((COALESCE(cr.recent_cogs, 0) * 2) / a.current_inventory_value)
        END
    , 0) AS days_inventory_outstanding
FROM cogs_full cf
JOIN dim_product p ON cf.product_id = p.product_id
JOIN avg_inventory a ON cf.product_id = a.product_id
LEFT JOIN cogs_recent cr ON cf.product_id = cr.product_id;
GO

-- =====================================================================
-- VIEW 7: Supplier Performance
-- Links supplier reliability_score and lead_time_days to actual
-- dead-stock outcomes
-- =====================================================================

CREATE VIEW vw_supplier_performance AS
WITH supplier_cogs AS (
    SELECT
        p.supplier_id,
        SUM(ABS(f.quantity) * p.unit_cost) AS total_cogs
    FROM fact_inventory_transactions f
    JOIN dim_product p ON f.product_id = p.product_id
    WHERE f.transaction_type = 'Sale'
      AND f.data_issue = 0
    GROUP BY p.supplier_id
),
supplier_dead_stock AS (
    SELECT
        p.supplier_id,
        COUNT(DISTINCT a.product_id) AS dead_product_count,
        SUM(a.tied_up_capital) AS dead_stock_capital
    FROM vw_stock_aging a
    JOIN dim_product p ON a.product_id = p.product_id
    WHERE a.aging_bucket = 'Dead Stock'
    GROUP BY p.supplier_id
),
supplier_product_count AS (
    SELECT
        supplier_id,
        COUNT(*) AS total_products_supplied
    FROM dim_product
    GROUP BY supplier_id
)
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    s.lead_time_days,
    s.reliability_score,
    spc.total_products_supplied,
    COALESCE(sc.total_cogs, 0)              AS total_cogs_contribution,
    COALESCE(sds.dead_product_count, 0)     AS dead_product_count,
    COALESCE(sds.dead_stock_capital, 0)     AS dead_stock_capital,
    ROUND(
        COALESCE(sds.dead_product_count, 0) * 100.0 / spc.total_products_supplied
    , 1) AS pct_products_dead
FROM dim_supplier s
JOIN supplier_product_count spc ON s.supplier_id = spc.supplier_id
LEFT JOIN supplier_cogs sc ON s.supplier_id = sc.supplier_id
LEFT JOIN supplier_dead_stock sds ON s.supplier_id = sds.supplier_id;
GO
