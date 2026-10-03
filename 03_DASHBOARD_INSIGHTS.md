# 📊 Dashboard Insights

This document presents the key business insights derived from each of the 5 Power BI dashboard pages. Each section covers what the visuals revealed, what it means for the business, and what action it points toward.

---

## Page 1 — Executive Overview

<p align="center">
  <img src="03_powerbi/dashboard_snapshots/1. executive_summary.PNG" width="800">
</p>

### 📌 Snapshot

| Metric | Value |
|---|---|
| Total Inventory Value | ৳6.08M |
| Dead Stock Value | ৳75.98K |
| Dead Stock % | 1.25% |
| Active Stock | 90.11% |
| Reorder Alert Count | 0 |

---

### 🔍 Insight 1 — Inventory Health Is Broadly Strong

90.11% of stock is actively moving, dead stock is contained at 1.25%, and no product needs immediate replenishment. The overall inventory position is healthy — but the healthy aggregate number masks a concentrated problem, which the deeper pages surface.

> 🔑 A low company-wide dead stock % can still hide a significant issue if that dead stock is entirely concentrated in specific products or suppliers — which it is here.

---

### 🔍 Insight 2 — Slow-Moving Stock Warrants Attention

8.64% of inventory is classified as Slow Moving. Without intervention, a portion of this could migrate into Dead Stock. The financial value locked in Slow Moving (৳0.53M) actually exceeds the Dead Stock value (৳75.98K) — making it the larger near-term capital risk.

**Recommendation:** Monitor slow-moving products proactively. Consider promotions, bundling, or warehouse redistribution before they cross into dead territory.

---

### 🔍 Insight 3 — Food & Beverage Is the Revenue Engine

| Category | Revenue |
|---|---|
| Food & Beverage | ৳14.5M |
| Personal Care | ৳5.7M |
| Home Care | ৳4.8M |
| Healthcare | ৳1.5M |
| Lifestyle | ৳0.1M |

Food & Beverage contributes more than double the next largest category. Any supplier disruption, forecasting error, or stockout in this category would have a disproportionate impact on overall business performance.

**Recommendation:** Maintain tighter inventory controls and higher service level targets for Food & Beverage SKUs.

---

### 🔍 Insight 4 — Dead Stock Risk Is Import-Specific

Singapore-sourced products account for the majority of dead stock capital. Indian-sourced products contribute a smaller share. Bangladesh-sourced products contribute virtually none. Dead stock is not a company-wide inventory problem — it is a specific, traceable sourcing risk concentrated in long-lead-time import suppliers.

**Recommendation:** Apply stricter demand validation before committing to large purchase orders from import suppliers, particularly for niche or low-demand product categories.

---

## Page 2 — ABC-XYZ Segmentation

<p align="center">
  <img src="03_powerbi/dashboard_snapshots/2. abc_xyc_segmentation.PNG" width="800">
</p>

### 📌 Snapshot

| Segment | Products | Revenue |
|---|---|---|
| AX | 7 | ৳9.48M |
| AY | 8 | ৳8.93M |
| BX | 5 | ৳2.81M |
| BY | 4 | ৳2.52M |
| CX | 4 | ৳1.85M |
| CY | 2 | ৳0.85M |
| CZ | 5 | ৳0.23M |

---

### 🔍 Insight 1 — AX and AY Together Drive ~69% of Revenue

AX (৳9.48M) and AY (৳8.93M) combined account for the overwhelming majority of business revenue. These 15 products are the core of the portfolio and deserve the highest inventory management priority — tighter forecasting, more frequent reviews, and zero tolerance for stockouts.

> 🔑 **No products fall in the AZ segment** — the company's highest-revenue products all have either stable or moderately predictable demand. Forecasting risk at the top of the portfolio is relatively low.

---

### 🔍 Insight 2 — CX Products Are Low Revenue, Not Low Value

Antacid Tablets, Harpic, Vim, and Savlon sit in the C-category (low revenue) but the X-category (stable demand). ABC Analysis alone would have flagged them as low-priority. XYZ reveals they move consistently year-round. These products play an operational role in the business that revenue numbers alone don't capture.

> 🔑 **Low revenue ≠ poor performance.** CX products should be managed for availability, not deprioritized.

---

### 🔍 Insight 3 — CZ Products Are the Portfolio's Dead Weight

The 5 CZ products (Premium Candle Set, Ceramic Mug Set, Aromatherapy Diffuser, Herbal Bath Salts, Imported Olive Oil) contribute only ৳0.23M (0.87% of total revenue) with an average CV of 166% and 17 zero-sale months out of 24. They are the weakest segment on both dimensions simultaneously — low revenue and erratic demand.

**Recommendation:** Review CZ products for discontinuation or liquidation. Avoid restocking until demand is validated.

---

### 🔍 Insight 4 — Food & Beverage Dominates High-Value Segments

Most AX and AY products belong to Food & Beverage — Fresh Soybean Oil, Pran Mustard Oil, Arla Milk Powder, Brooke Bond Red Label, Nescafe Classic, Bashundhara Sugar, Taaza Tea. This category drives both the highest revenue and the most consistent demand in the portfolio.

**Recommendation:** Develop contingency sourcing plans for key Food & Beverage SKUs to protect against supplier disruptions.

---

### 🔍 Insight 5 — Demand Variability Differs Even Within the Same Revenue Tier

Fresh Soybean Oil 2L (AX, CV: 18.41%) and Surf Excel 1kg (AY, CV: 21.89%) generate comparable revenue but require different forecasting approaches. AY products need higher safety stock and more frequent review cycles than AX products, even when their revenue contribution looks similar.

**Recommendation:** Use different replenishment rules for X and Y products rather than applying a single blanket policy across all A-category items.

---

## Page 3 — Dead & Slow Stock Report

<p align="center">
  <img src="03_powerbi/dashboard_snapshots/3. dead_and_slow_stock.PNG" width="800">
</p>

### 📌 Snapshot

| Metric | Value |
|---|---|
| Dead Stock Item Count | 15 product-warehouse combinations |
| Dead Stock Value | ৳75,980 |
| Dead Stock % | 1.25% |
| Average Idle Days | 538 days |
| Longest Idle Period | 657 days (Herbal Bath Salts, WH002) |

---

### 🔍 Insight 1 — 538 Days Is the Real Story, Not 1.25%

The percentage sounds manageable. The idle duration doesn't. An average of 538 days means these products have sat through multiple replenishment cycles, multiple seasonal windows, and multiple procurement reviews — without moving. This is not a recent problem; it has been accumulating for over a year and a half.

> 🔑 **The financial figure (৳75,980) understates the operational cost.** Warehouse space, holding costs, and opportunity cost of that capital compound over 500+ days.

---

### 🔍 Insight 2 — Lifestyle Drives More Than Half of Dead Stock Capital

| Category | Dead Stock Value | Share |
|---|---|---|
| Lifestyle | ৳41,950 | 55.2% |
| Food & Beverage | ৳19,680 | 25.9% |
| Personal Care | ৳14,350 | 18.9% |

Lifestyle products — a niche, non-essential category — account for the majority of dead capital. This suggests demand for these products was significantly overestimated at the time of purchase.

**Recommendation:** Reassess demand forecasting for niche categories. Introduce a demand-validation step (pilot batch) before full purchase commitments on any Lifestyle or specialty SKU.

---

### 🔍 Insight 3 — The Same 5 Products Appear Across All 3 Warehouses

Dead stock is not a warehouse-specific problem. The same 5 products (Premium Candle Set, Ceramic Mug Set, Aromatherapy Diffuser, Herbal Bath Salts, Imported Olive Oil) appear as dead stock across Dhaka Central, Chittagong Port, and Sylhet Hub — confirming this is a **purchasing decision issue**, not a local distribution issue.

**Recommendation:** Treat these as portfolio-level decisions, not warehouse-level fixes. Avoid redistributing dead stock between locations without a plan to actually sell it.

---

### 🔍 Insight 4 — Imported, Niche Products Show the Highest Dead Stock Risk

All 5 dead-stock products are imported, niche, or premium items with highly irregular demand (CZ in the ABC-XYZ matrix). Long lead times forced larger buffer purchases, and when demand didn't materialise, those buffers became stranded capital.

**Recommendation:** Apply smaller, more frequent purchase orders for imported specialty products. Combine ABC-XYZ classification with purchasing decisions to prevent future dead stock accumulation.

---

## Page 4 — Reorder Alert Panel

<p align="center">
  <img src="03_powerbi/dashboard_snapshots/4. reorder_alert_panel.PNG" width="800">
</p>

### 📌 Snapshot

| Metric | Value |
|---|---|
| Items to Reorder | 0 |
| Total Products Monitored | 35 |
| Average Lead Time | 11 days |
| All Products | Sufficient Stock |

---

### 🔍 Insight 1 — Zero Reorder Alerts Is a Signal, Not Just Good News

Every product sits well above its calculated reorder point. At face value, this means no stockout risk. But read alongside the Inventory Turnover and Stock Aging findings, it tells a different story — the company maintains such large buffers across the board that nothing ever gets close to a reorder trigger. This is the same procurement pattern that created the dead stock in the first place.

> 🔑 **Zero reorder alerts ≠ optimal inventory. It may mean the company is systematically over-buying across the portfolio.**

---

### 🔍 Insight 2 — Current Stock Is Many Times Higher Than Reorder Points

| Product | Current Stock | Reorder Point |
|---|---|---|
| ACI Salt 1kg | 7,179 | 363 |
| Colgate Toothpaste 150g | 6,976 | 451 |
| Bashundhara Sugar 1kg | 6,403 | 225 |
| Dove Soap 75g | 5,495 | 312 |

These gaps suggest procurement has been consistently ordering far more than demand requires. While this protects against stockouts, it also locks capital unnecessarily and inflates holding costs.

**Recommendation:** Review purchase quantities for overstocked products. Balance service-level goals against the cost of carrying excess inventory.

---

### 🔍 Insight 3 — Import Suppliers Require Longer Planning Horizons

| Supplier | Lead Time |
|---|---|
| Pacific Imports Ltd 🇸🇬 | 28 days |
| Globe Traders (Import) 🇮🇳 | 21 days |
| Nestle Bangladesh 🇧🇩 | 12 days |
| Bashundhara Group 🇧🇩 | 4 days |

Import suppliers need 2–7x longer to replenish than local suppliers. For high-demand products, this justifies maintaining larger safety stock. For low-demand niche products, it explains why over-ordering is so common — and so risky.

**Recommendation:** Segment reorder policies by supplier lead time. Don't apply the same buffer logic to a 4-day local supplier and a 28-day import supplier.

---

### 🔍 Insight 4 — Master Data Reorder Levels Need Updating

Calculated reorder points frequently differ substantially from the static reorder levels stored in product master data. The master data appears to reflect historical rules rather than current demand patterns and lead times.

**Recommendation:** Replace static master data reorder levels with data-driven calculations updated periodically based on recent sales behavior and current lead times.

---

## Page 5 — Trend Analysis

<p align="center">
  <img src="03_powerbi/dashboard_snapshots/5. trend_analysis.PNG" width="800">
</p>

### 📌 Snapshot

| Category | Avg Turnover Ratio |
|---|---|
| Food & Beverage | 1.54 |
| Healthcare | 1.52 |
| Home Care | 1.34 |
| Personal Care | 1.24 |
| Lifestyle | 0.00 |

---

### 🔍 Insight 1 — Sales Were Stable; Purchases Were Not

Monthly sales remained relatively consistent throughout the 24-month period. Purchase volumes, however, fluctuated significantly — with large spikes that were not followed by proportional increases in sales. This confirms that procurement decisions were not tightly linked to actual demand patterns.

> 🔑 **This purchase-sales mismatch is the upstream cause of the inventory inefficiency identified throughout the other four dashboard pages.**

**Recommendation:** Align procurement more closely with rolling sales forecasts. Large bulk purchases should be justified by verified seasonal demand, not precautionary stocking.

---

### 🔍 Insight 2 — Lifestyle Category Effectively Stopped Selling After July 2023

The Lifestyle line on the Seasonal Pattern chart is nearly flat to zero from mid-2023 onward. This is not a seasonal dip — it's a sustained demand collapse that never recovered. Combined with a turnover ratio of 0.00 and 657-day idle periods in the Dead Stock report, the picture is unambiguous.

**Recommendation:** Discontinue or liquidate all active Lifestyle inventory. Do not reorder until genuine demand is established through a market test.

---

### 🔍 Insight 3 — Healthcare Is the Most Inventory-Efficient Category

Healthcare achieves a turnover ratio of 1.52 — second only to Food & Beverage — despite generating relatively modest revenue. Products like Paracetamol and Antacid Tablets convert inventory investment into sales faster and more consistently than most of the portfolio.

**Recommendation:** Use Healthcare inventory practices as a benchmark for other categories. The combination of steady demand and appropriate stock levels in this category is worth replicating elsewhere.

---

### 🔍 Insight 4 — Personal Care Has the Lowest Turnover Among Active Categories

At 1.24, Personal Care generates substantial revenue but holds inventory longer than any other active category. This suggests some products in this category may be overstocked relative to their actual sales velocity.

**Recommendation:** Review stock levels for slower-moving Personal Care SKUs. Cross-reference with ABC-XYZ classification to identify any AY or BY products that may benefit from reduced purchase quantities.

---

### 🔍 Insight 5 — Most Categories Show Stable Seasonal Patterns

Sales fluctuate moderately throughout the year but do not show extreme spikes or crashes for most categories. This aligns with the XYZ finding that 86% of products fall into X or Y — the portfolio is largely forecastable, which means most inventory problems stem from procurement decisions, not inherently unpredictable demand.

> 🔑 **When demand is mostly predictable, overstock is a process problem — not a market problem. It can be fixed.**

---

## 🔗 How the 5 Pages Connect

Each dashboard page answers one question and sets up the next:

```
Executive Overview    → Is the business healthy overall?
        ↓
ABC-XYZ Segmentation  → Which products are strategically important
                         vs. genuinely problematic?
        ↓
Dead & Slow Stock     → Where exactly is capital locked,
                         and for how long?
        ↓
Reorder Alert Panel   → Does anything need replenishment now?
                         (And is the company over-buying everywhere?)
        ↓
Trend Analysis        → What does the time dimension reveal
                         about purchasing behavior and category health?
```

The answer to each question makes the next question more specific — and more actionable.
