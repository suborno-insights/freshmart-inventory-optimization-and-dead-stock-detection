# DAX Measures Reference

This document lists every DAX measure used across the 5-page Power BI dashboard, grouped by the page where it's primarily used. All measures live in a dedicated `_Measures` table inside the `.pbix` file (a common Power BI best practice for keeping measures organized and easy to find).

---

## Page 1 — Executive Overview

**Total Inventory Value**
```dax
Total Inventory Value = SUM(vw_stock_aging[tied_up_capital])
```

**Total Inventory Units**
```dax
Total Inventory Units = SUM(vw_stock_aging[current_stock])
```

**Dead Stock Value**
```dax
Dead Stock Value =
CALCULATE(
    SUM(vw_stock_aging[tied_up_capital]),
    vw_stock_aging[aging_bucket] = "Dead Stock"
)
```

**Dead Stock %**
```dax
Dead Stock % =
DIVIDE([Dead Stock Value], [Total Inventory Value], 0)
```

**Active Stock Value**
```dax
Active Stock Value =
CALCULATE(
    SUM(vw_stock_aging[tied_up_capital]),
    vw_stock_aging[aging_bucket] = "Active"
)
```

**Reorder Alert Count**

> Note: when no product currently needs reordering, `CALCULATE` returns
> `BLANK()` rather than `0`, which displays as `--` on a card visual.
> `COALESCE` forces it to display as a proper `0` instead.

```dax
Reorder Alert Count =
VAR AlertCount =
    CALCULATE(
        DISTINCTCOUNT(vw_reorder_analysis[product_id]),
        vw_reorder_analysis[reorder_status] = "Reorder Now"
    )
RETURN
    COALESCE(AlertCount, 0)
```

**A Category Count**
```dax
A Category Count =
CALCULATE(
    DISTINCTCOUNT(vw_abc_analysis[product_id]),
    vw_abc_analysis[abc_category] = "A"
)
```

**CZ Segment Count**
```dax
CZ Segment Count =
CALCULATE(
    DISTINCTCOUNT(vw_abc_xyz_matrix[product_id]),
    vw_abc_xyz_matrix[combined_segment] = "CZ"
)
```

**CZ Segment Revenue**
```dax
CZ Segment Revenue =
CALCULATE(
    SUM(vw_abc_xyz_matrix[total_revenue]),
    vw_abc_xyz_matrix[combined_segment] = "CZ"
)
```

**Total Revenue**
```dax
Total Revenue = SUM(vw_abc_analysis[total_revenue])
```

**Import Supplier Dead Stock %**

> Shows what share of total dead-stock capital came from non-local
> (import) suppliers — used to support the supplier-risk finding.

```dax
Import Supplier Dead Stock % =
DIVIDE(
    CALCULATE(
        SUM(vw_supplier_performance[dead_stock_capital]),
        vw_supplier_performance[country] <> "Bangladesh"
    ),
    SUM(vw_supplier_performance[dead_stock_capital]),
    0
)
```

---

## Page 2 — ABC-XYZ Segmentation

**Segment Product Count**
```dax
Segment Product Count = DISTINCTCOUNT(vw_abc_xyz_matrix[product_id])
```

**Segment Revenue**
```dax
Segment Revenue = SUM(vw_abc_xyz_matrix[total_revenue])
```

*(Used as the matrix heatmap's color-by value — driving the conditional background-color gradient across the 9-segment grid.)*

---

## Page 3 — Dead & Slow Stock Report

**Dead Stock Capital**
```dax
Dead Stock Capital =
CALCULATE(
    SUM(vw_stock_aging[tied_up_capital]),
    vw_stock_aging[aging_bucket] = "Dead Stock"
)
```

**Dead Stock Item Count**

> Counts product-warehouse *combinations*, not unique products — this
> intentionally matches the granularity of the "Top Dead Stock Items"
> table (15 rows), not the unique product count (5).

```dax
Dead Stock Item Count =
CALCULATE(
    COUNTROWS(vw_stock_aging),
    vw_stock_aging[aging_bucket] = "Dead Stock"
)
```

**Average Idle Days**
```dax
Average Idle Days =
CALCULATE(
    AVERAGE(vw_stock_aging[days_since_last_sale]),
    vw_stock_aging[aging_bucket] = "Dead Stock"
)
```

---

## Page 4 — Reorder Alert Panel

**Average Supplier Lead Time**
```dax
Avg Lead Time = AVERAGE(dim_supplier[lead_time_days])
```

**Total Products Monitored**
```dax
Total Products Monitored = DISTINCTCOUNT(vw_reorder_analysis[product_id])
```

**Reorder Sort Priority** *(Calculated Column, not a measure)*

> Used purely to force "Reorder Now" rows to sort above "Sufficient
> Stock" rows in the status table — DAX measures can't be used for
> row-level custom sort, so this is a calculated column instead.

```dax
Reorder Sort Priority =
IF(vw_reorder_analysis[reorder_status] = "Reorder Now", 1, 2)
```

*(`Reorder Alert Count`, defined under Page 1, is reused here.)*

---

## Page 5 — Trend Analysis

**Monthly Sales Value**
```dax
Monthly Sales Value =
CALCULATE(
    SUMX(fact_inventory_transactions, ABS(fact_inventory_transactions[quantity]) * fact_inventory_transactions[unit_price]),
    fact_inventory_transactions[transaction_type] = "Sale",
    fact_inventory_transactions[data_issue] = 0
)
```

**Monthly Purchase Value**
```dax
Monthly Purchase Value =
CALCULATE(
    SUMX(fact_inventory_transactions, fact_inventory_transactions[quantity] * fact_inventory_transactions[unit_price]),
    fact_inventory_transactions[transaction_type] = "Purchase",
    fact_inventory_transactions[data_issue] = 0
)
```

**Average Turnover Ratio**
```dax
Avg Turnover Ratio = AVERAGE(vw_inventory_turnover[annualized_turnover_ratio])
```

**Average Days Inventory Outstanding**
```dax
Avg DIO = AVERAGE(vw_inventory_turnover[days_inventory_outstanding])
```

---

## Design Notes

- **`DIVIDE()` instead of `/`** is used everywhere a ratio is calculated, since it returns a safe fallback value (usually `0`) instead of throwing a division-by-zero error.
- **`CALCULATE()`** is the backbone of almost every conditional measure here — it temporarily applies a filter (e.g., "only Dead Stock rows") before aggregating.
- **`COALESCE()`** is used specifically where a `CALCULATE` filter can return zero matching rows, which DAX treats as `BLANK()` rather than `0` — and `BLANK()` renders as a confusing `--` on card visuals.
- All measures referencing `data_issue = 0` are intentionally filtering out the rows flagged during the SQL data-quality fixes (see `02_sql/03_data_quality_fixes.sql`), so the dashboard never includes excluded/unreliable data.
