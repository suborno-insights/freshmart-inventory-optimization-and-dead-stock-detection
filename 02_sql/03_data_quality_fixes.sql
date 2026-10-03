/* =====================================================================
   RetailMart BD — Inventory Optimization & Dead Stock Detection
   03_data_quality_fixes.sql

   Purpose: Correct quantity sign errors, recalculate stock_balance,
            and flag (not delete) rows with unresolvable data quality
            issues -- preserving a full audit trail.
   ===================================================================== */

USE RetailMart_BD;
GO

-- =====================================================================
-- 1. Ensure correct sign on quantity by transaction type
--    Sale = negative (outflow) | Purchase/Return = positive (inflow)
-- =====================================================================

UPDATE fact_inventory_transactions
SET quantity = -ABS(quantity)
WHERE transaction_type = 'Sale';
GO

UPDATE fact_inventory_transactions
SET quantity = ABS(quantity)
WHERE transaction_type IN ('Purchase', 'Return');
GO

-- Recalculate total_amount after sign correction
UPDATE fact_inventory_transactions
SET total_amount = ABS(quantity) * unit_price;
GO

-- =====================================================================
-- 2. Flag rows with zero quantity (originally NULL, became 0 in transit)
-- =====================================================================

UPDATE fact_inventory_transactions
SET data_issue = 1
WHERE quantity = 0
  AND transaction_type IN ('Sale', 'Purchase');
GO

-- =====================================================================
-- 3. Recalculate stock_balance using a running total per
--    (product_id, warehouse_id), excluding flagged rows
-- =====================================================================

WITH running_balance AS (
    SELECT
        transaction_id,
        SUM(quantity) OVER (
            PARTITION BY product_id, warehouse_id
            ORDER BY transaction_date, transaction_id
        ) AS calculated_balance
    FROM fact_inventory_transactions
    WHERE data_issue = 0
)
UPDATE f
SET f.stock_balance = rb.calculated_balance
FROM fact_inventory_transactions f
JOIN running_balance rb
    ON f.transaction_id = rb.transaction_id;
GO

-- =====================================================================
-- 4. Flag any remaining rows where stock_balance is negative
--    (root cause: opening-stock / first-sale timing overlap --
--     see INSIGHT_REPORT_EN.md, Section 7, for full explanation)
-- =====================================================================

UPDATE fact_inventory_transactions
SET data_issue = 1
WHERE stock_balance < 0;
GO

-- Re-run the balance recalculation to exclude the newly flagged rows
WITH running_balance AS (
    SELECT
        transaction_id,
        SUM(quantity) OVER (
            PARTITION BY product_id, warehouse_id
            ORDER BY transaction_date, transaction_id
        ) AS calculated_balance
    FROM fact_inventory_transactions
    WHERE data_issue = 0
)
UPDATE f
SET f.stock_balance = rb.calculated_balance
FROM fact_inventory_transactions f
JOIN running_balance rb
    ON f.transaction_id = rb.transaction_id;
GO

-- Explicitly null out stock_balance for flagged rows so no stale
-- (and potentially negative) values remain visible
UPDATE fact_inventory_transactions
SET stock_balance = NULL
WHERE data_issue = 1;
GO

-- =====================================================================
-- 5. Verification queries
-- =====================================================================

-- Confirm sign correction worked
SELECT transaction_type, MIN(quantity) AS min_qty, MAX(quantity) AS max_qty
FROM fact_inventory_transactions
WHERE data_issue = 0
GROUP BY transaction_type;

-- Confirm no negative balances remain among clean rows
SELECT COUNT(*) AS negative_balance_count
FROM fact_inventory_transactions
WHERE stock_balance < 0;

-- Final flag summary
SELECT
    data_issue,
    COUNT(*) AS row_count,
    SUM(CASE WHEN stock_balance IS NULL THEN 1 ELSE 0 END) AS null_balance_count
FROM fact_inventory_transactions
GROUP BY data_issue;
