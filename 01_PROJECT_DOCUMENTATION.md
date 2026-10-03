# Project Documentation

## 1️⃣ Executive Summary

### 📌 Headline Numbers

| Metric | Value |
|---|---|
| Total Inventory Value | ৳6.08M |
| Dead Stock Value | ৳75,980 (1.25%) |
| Dead Stock Products | 5 SKUs across 15 product-warehouse combinations |
| Average Idle Days (Dead Stock) | 538 days |
| Dead Stock Traced to Import Suppliers | 100% |
| Reorder Alert Count | 0 |
| Company-wide Inventory Turnover | ~1.3x (healthy benchmark: 4–8x) |
| Total Revenue (24 months) | ৳26.67M |

---

RetailMart BD's overall inventory position is broadly healthy — 90.11% of stock is actively moving and no product is at risk of stocking out. But beneath the healthy aggregate sits a clear, traceable problem: **৳75,980 locked in 5 dead products that have not sold in an average of 538 days**, with 100% of that capital originating from just 2 of 10 suppliers.

The deeper issue is systemic. Even among active products, inventory turnover (~1.3x) sits well below the 4–8x range typical for healthy FMCG operations — confirming that the dead stock problem is the most visible symptom of a broader, buffer-heavy procurement pattern that applies across the entire portfolio.

The company does not have a stockout problem. It has a **capital efficiency problem** — and this report identifies exactly where it is concentrated, why it happened, and what to do about it.

---

## 2️⃣ Project Background & Objective

RetailMart BD is a mid-sized FMCG retail company operating 3 warehouses (Dhaka Central, Chittagong Port, Sylhet Hub) and managing 35 SKUs sourced from 10 suppliers and distributed nationwide.

Inventory management had been entirely reactive and intuition-driven — with no data-backed system to identify which products were tying up capital, which carried stockout risk, or when and how much to reorder.

### Three Objectives

| # | Objective |
|---|---|
| 1 | **Inventory Segmentation** — classify products by revenue contribution and demand predictability using ABC-XYZ analysis |
| 2 | **Dead & Slow Stock Identification** — determine which products have been inactive, for how long, and how much capital is at risk |
| 3 | **Proactive Reorder Intelligence** — build an early-warning system that flags risk before stockouts occur |

---

## 3️⃣ Methodology

| Phase | Tool | What Was Done |
|---|---|---|
| Data Cleaning | Excel | Fixed date formats, transaction-type inconsistencies, missing values, sign errors |
| Data Modeling | SQL Server | Star Schema — 1 fact table, 4 dimension tables, recalculated stock balance via window functions |
| Analysis | SQL Server | 7 analytical views across 8 analytical frameworks |
| Visualization | Power BI | 5-page interactive dashboard with DAX measures and cross-filtering |

### Data Quality Approach

No data was deleted. Every quality issue was root-caused and flagged via a `data_issue` column, then excluded from downstream calculations — preserving a complete audit trail. A total of **138 transactions (~1.5%)** were flagged this way.

> **Notable issues resolved:** mixed date formats (3 different patterns in one column), quantity sign errors, missing supplier IDs recovered via product-supplier lookup, XYZ calculations rebuilt over a complete 24-month grid after discovering that missing months were being silently excluded (which caused dead-stock products to appear falsely stable), and ~0.4% of transactions with impossible negative stock balances traced to an opening-stock timing overlap and flagged rather than deleted.

---

## 4️⃣ Key Findings

### 🔍 Finding 1 — ABC-XYZ Segmentation Isolates a Specific Risk Pool

ABC-XYZ analysis placed 5 of 35 SKUs in the **CZ segment** — the lowest revenue contribution (0.87% of total) combined with the most erratic demand (CV 160–170%, versus 14–31% for most products). Each of these 5 products recorded **17 zero-sale months out of 24**.

> 🔑 **ABC alone couldn't find them.** The C-category also contained 6 other products (Antacid Tablets, Harpic, Vim, Savlon, Mango Juice, Sensodyne) that are low-revenue but stable (CX/CY). Without XYZ layered on top, all 11 C-category products would have looked the same. Only the combined matrix separated "low-revenue but healthy" from "genuinely dead."

---

### 🔍 Finding 2 — ৳75,980 Tied Up, Idle for an Average of 538 Days

Stock Aging Analysis confirmed 15 dead product-warehouse combinations across 5 SKUs, with idle periods ranging from 523 to 657 days. Herbal Bath Salts at WH002 holds the longest record at **657 days without a single sale**.

> 🔑 **The 1.25% figure understates the real cost.** Warehouse space, holding costs, and the opportunity cost of that capital compound over 500+ idle days. This capital was recoverable — it resulted from an overestimate of demand made at the time of purchase, not from an inherent market failure.

---

### 🔍 Finding 3 — 100% of Dead Stock Traces to 2 Import Suppliers

| Supplier | Country | Lead Time | Reliability Score | Dead Capital | Dead % of Portfolio |
|---|---|---|---|---|---|
| Pacific Imports Ltd | 🇸🇬 Singapore | 28 days | 72 | ৳61,630 | 81% |
| Globe Traders (Import) | 🇮🇳 India | 21 days | 78 | ৳14,350 | 19% |
| All 8 local suppliers | 🇧🇩 Bangladesh | 4–12 days | 80–95 | ৳0 | 0% |

> 🔑 **This is not a coincidence — it's a procurement risk pattern.** The `reliability_score` in supplier master data independently rated these two suppliers lowest, and the actual outcome confirms that signal. Two independent data sources pointing at the same two suppliers.

Long lead times (21–28 days vs. 4–12 days for local suppliers) forced larger buffer orders to protect against stockouts — but for niche, low-demand products, those buffers became stranded capital when demand didn't materialise.

---

### 🔍 Finding 4 — Low Turnover Is a Company-wide Issue, Not Just a Dead Stock Problem

Even active products top out at a turnover ratio of ~2.9x (Maggi Noodles). The healthy FMCG benchmark is 4–8x. Every category falls short:

| Category | Avg Turnover | Avg DIO |
|---|---|---|
| Food & Beverage | 1.54x | 290 days |
| Healthcare | 1.52x | 242 days |
| Home Care | 1.34x | 275 days |
| Personal Care | 1.24x | 360 days |
| Lifestyle | 0.00x | 999 days |

> 🔑 **Dead stock is the most visible symptom of a broader procurement pattern.** The Reorder Alert Count of 0 (no product needs replenishment) confirms this: the company maintains such large buffers across all products that nothing ever approaches a reorder trigger — which is exactly the same behavior that created the dead stock in the first place.

---

### 🔍 Finding 5 — Stockout and Dead Stock Are Two Symptoms of the Same Root Cause

With 0 reorder alerts and every product comfortably above its calculated reorder point, there is no immediate stockout risk. But this "safety" has a hidden cost — the same buffer-heavy procurement policy that prevents stockouts is also the reason inventory turnover is low and dead stock accumulated.

> 🔑 **The company doesn't have a stockout problem or a dead stock problem in isolation. It has a procurement strategy that optimizes purely for availability, without accounting for demand volatility or capital efficiency.**

---

## 5️⃣ Recommendations

### 🔴 Immediate (0–30 days)

**R1 — Liquidate the 5 CZ Products**
Launch a clearance campaign (30–50% discount, or bundling with fast-moving products) to recover at least partial capital from the ৳75,980 currently locked in Premium Candle Set, Ceramic Mug Set, Aromatherapy Diffuser, Herbal Bath Salts, and Imported Olive Oil.
*(Findings 1, 2)*

**R2 — Place a Hold on Future Reordering for These 5 Products**
Add a manual procurement hold in the system until genuine demand is validated. The current stock of 4–60 units per warehouse far exceeds any calculated reorder point.
*(Finding 2)*

---

### 🟡 Short-term (1–3 months)

**R3 — Revise Order Policy for Pacific Imports and Globe Traders**
Shift from large bulk orders to smaller, more frequent orders for products sourced from these two suppliers — reducing the exposure when demand for niche products doesn't materialise.
*(Finding 3)*

**R4 — Introduce a Demand-Validation Step for Niche Categories**
Before committing to a full purchase order on any Lifestyle or specialty SKU, run a small pilot batch (10–20% of the intended order) to validate actual demand. Only proceed with the full order once the pilot confirms take-up.
*(Findings 1, 3)*

---

### 🟢 Long-term (3–6+ months)

**R5 — Build a Demand-Volatility-Based Procurement Policy**
Formally incorporate XYZ classification into procurement decisions — large buffer orders for X-category products (stable demand), small and conservative orders for Z-category products (erratic demand). Document this as a Standard Operating Procedure so it becomes a repeatable system, not an ad hoc decision.
*(Findings 4, 5)*

**R6 — Explore Local Sourcing Alternatives for Niche Products**
Where possible, identify lower-lead-time local or regional suppliers for specialty categories. Shorter lead times reduce the need for large buffer purchases and lower the risk of overstocking.
*(Finding 3)*

**R7 — Establish a Quarterly Inventory Health Review**
Treat this dashboard as a living tool, not a one-time analysis. A quarterly review cycle would catch emerging CZ products before they accumulate 500+ idle days — the problem identified here had been building for over 18 months before it was surfaced.

---

## 6️⃣ Expected Impact

| Timeframe | Expected Outcome |
|---|---|
| **Immediate** | Liquidation of CZ products could recover an estimated 40–60% of tied-up capital (~৳30,000–45,000) through clearance pricing |
| **Medium-term** | Revised import supplier order policy should meaningfully reduce the risk of future dead stock accumulation in niche categories |
| **Long-term** | A demand-volatility-based procurement policy could gradually move the company's inventory turnover ratio from ~1.3x toward the industry-standard 4–8x range |

> **Caveat:** These are reasoned estimates based on dataset patterns, not the result of a financial audit. A small-scale pilot is recommended before full implementation to validate actual impact.

---

## 7️⃣ Data Quality & Limitations

| Issue | How It Was Handled |
|---|---|
| Mixed date formats (3 patterns in one column) | Manual string parsing using `LEFT`/`MID`/`RIGHT` + `DATE()` — `DATEVALUE()` couldn't reliably distinguish `D/M/YYYY` from `M-D-YYYY` |
| Quantity sign errors (all quantities made positive by a bulk fix) | Re-applied sign correction by transaction type; recalculated stock balance from scratch |
| NULL quantities silently converted to 0 during load | Flagged via `data_issue = 1`; excluded from all calculations |
| XYZ CV calculated only over active-selling months | Rebuilt over a complete 24-month grid — missing months = 0, not excluded |
| Reorder Point falsely flagged a dead product as "Reorder Now" | Average daily sales recalculated over full 730-day period, not just active-selling days |
| ~0.4% of transactions with negative stock balances | Traced to opening-stock timing overlap; flagged and excluded, not deleted |
| Inventory Turnover uses period-end inventory as proxy for average inventory | A simplification — noted in analysis; full financial audit would use monthly average |
| "Slow Moving" bucket includes products near the dataset cutoff | These are not genuinely at risk — their classification is an artifact of the 2024-12-31 reference date |

**Total flagged transactions:** 138 (~1.5%) — excluded from analysis, retained in database with full audit trail.

---

## 8️⃣ Appendix — Dashboard Structure

| Page | Focus |
|---|---|
| **1 — Executive Overview** | Company-wide KPIs, aging distribution, revenue by category, dead stock by supplier country |
| **2 — ABC-XYZ Segmentation** | 9-segment heatmap matrix, segment-wise revenue, product-level drill-down |
| **3 — Dead & Slow Stock Report** | Aging analysis, financial impact by category, top dead-stock items by idle days |
| **4 — Reorder Alert Panel** | Reorder status by product, supplier lead-time comparison |
| **5 — Trend Analysis** | Monthly sales vs. purchase trend, seasonal patterns, turnover by category |

📸 Dashboard screenshots → [`/04_screenshots`](03_powerbi/dashboard_snapshots)

📊 Full analysis findings → [`ANALYSIS_FINDINGS.md`](./ANALYSIS_FINDINGS.md)

📈 Dashboard page insights → [`DASHBOARD_INSIGHTS.md`](./DASHBOARD_INSIGHTS.md)
