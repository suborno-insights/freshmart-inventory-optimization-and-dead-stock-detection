# 📊 Analysis Findings

This document summarizes the business insights derived from 8 analytical frameworks applied to RetailMart BD's 24-month inventory transaction data (January 2023 – December 2024). Each section explains what the data showed, why it matters, and what it couldn't answer on its own — leading naturally into the next analysis.

---

## 1️⃣ ABC Analysis

### 🔍 Key Findings

- Revenue is heavily concentrated. Just **15 Category A products drive ~69% of total revenue** — a textbook Pareto distribution across a 35-SKU portfolio.
- **Fresh Soybean Oil 2L** is the single largest revenue contributor at **7.8%** of total revenue, making it the most critical product for stock availability.
- **Category C contains 11 products** with low revenue contribution — but not all of them are problematic. Several (Antacid Tablets, Harpic, Vim, Savlon) belong to active, everyday categories like Healthcare and Home Care, where low revenue simply reflects low unit price, not low demand.

### 💡 Business Implication

Category A products deserve the tightest inventory control — a stockout on any of these directly impacts revenue. Category C products should not be treated uniformly; some may still move consistently despite modest revenue numbers.

### ⚠️ Limitation

ABC Analysis measures **revenue contribution only** — it says nothing about demand consistency or how long stock has been sitting. Two products can have identical revenue and completely different inventory health. This is why XYZ Analysis follows.

---

## 2️⃣ XYZ Analysis

### 🔍 Key Findings

| Category | Products | Demand Pattern |
|---|---|---|
| X — Stable | 16 | Low variability, easy to forecast |
| Y — Variable | 14 | Moderate variability, manageable |
| Z — Erratic | 5 | High variability, difficult to forecast |

- **86% of products (30 of 35) fall in X or Y** — most of the portfolio has reasonably predictable demand, which is a healthy signal for a supply chain operation.
- The **5 Z-category products** each recorded **17 zero-sale months out of 24** and a Coefficient of Variation above 160% — far beyond the 50% threshold for Z classification.

> 🔑 **The products in Z are not just low-revenue — they are effectively inactive.**

### 💡 Business Implication

An important distinction surfaces here: products like Antacid Tablets and Savlon appeared in ABC's C-category (low revenue) but are X-category in XYZ (stable demand). They belong to a completely different risk tier than the Z-category products, even though ABC grouped them together.

### ⚠️ Limitation

XYZ Analysis measures demand variability but ignores revenue contribution. A product can be X-category (stable) while still generating negligible revenue. For inventory decisions, neither analysis is sufficient alone — which is why they are combined next.

---

## 3️⃣ ABC-XYZ Matrix Analysis

### 🔍 Key Findings

| Segment | Products | Revenue |
|---|---|---|
| AX | 7 | ৳9.48M |
| AY | 8 | ৳8.93M |
| BX | 5 | ৳2.81M |
| BY | 4 | ৳2.52M |
| CX | 4 | ৳1.85M |
| CY | 2 | ৳0.85M |
| CZ | 5 | ৳0.23M |

- **No AZ products exist** — none of the company's highest revenue-generating products suffer from erratic demand. The top of the portfolio is both valuable and forecastable.
- **AX + AY together generate over ৳18M** — these 15 products are the business's core, and their inventory health directly determines company performance.
- **CX products** (Antacid Tablets, Harpic, Vim, Savlon) confirm an important principle: low revenue does not mean poor performance. These products maintain consistent demand and serve an operational role despite modest revenue figures.
- **CZ products** contribute only ৳0.23M (0.87% of total revenue) while showing an average CV of 166% and 17 zero-sale months — the clearest dead stock signal in the entire portfolio.

### ⚠️ Limitation

The ABC-XYZ Matrix identifies *what* the inventory looks like today in terms of revenue and demand — but it cannot tell you *how long* inventory has been sitting unsold. A CZ product could have been inactive for 30 days or 600 days. To answer that question, Stock Aging Analysis is required.

---

## 4️⃣ Stock Aging Analysis

### 🔍 Key Findings

| Aging Bucket | Product-Warehouse Combinations | Units | Tied-Up Capital |
|---|---|---|---|
| 🟢 Active | 84 | 103,409 | ৳5.48M |
| 🟡 Slow Moving | 6 | 9,190 | ৳0.53M |
| 🔴 Dead Stock | 15 | 212 | ৳75,980 |

- **84 of 105 product-warehouse combinations are Active** — the majority of inventory is moving regularly, which reflects a generally healthy stock position.
- **Slow Moving inventory (৳0.53M)** carries more tied-up capital than Dead Stock in absolute terms — a reminder that management attention should not be narrowly focused on dead stock alone.
- **15 Dead Stock combinations** involve only 5 unique products, with idle periods ranging from **523 to 657 days**. Herbal Bath Salts (WH002) holds the longest idle record at **657 days**.

> 🔑 **The Slow Moving products are not genuinely at risk.** Their classification is an artifact of the dataset's cutoff date (2024-12-31) — their most recent sale fell just beyond the 30-day Active threshold. In a live system with a rolling reference date, most would remain Active.

### ⚠️ Limitation

Stock Aging Analysis reveals how old inventory is, but not whether current stock levels are proportionate to expected demand. A product can be Active while still carrying excess stock. To measure inventory utilization efficiency, Reorder Point and Inventory Turnover analyses follow.

---

## 5️⃣ Dead Stock Financial Impact Analysis

### 🔍 Key Findings

**By Category:**
| Category | Dead Stock Capital | Share |
|---|---|---|
| 🏮 Lifestyle | ৳41,950 | 55.2% |
| 🫒 Food & Beverage | ৳19,680 | 25.9% |
| 🧴 Personal Care | ৳14,350 | 18.9% |

**By Supplier:**
| Supplier | Country | Dead Stock Capital | % of Dead Total |
|---|---|---|---|
| Pacific Imports Ltd | 🇸🇬 Singapore | ৳61,630 | 81% |
| Globe Traders (Import) | 🇮🇳 India | ৳14,350 | 19% |
| All other 8 suppliers | 🇧🇩 Bangladesh | ৳0 | 0% |

- **100% of dead stock capital traces back to just 2 of 10 suppliers** — both import suppliers with the longest lead times in the network (21–28 days vs. 4–12 days for local suppliers).
- **Pacific Imports Ltd alone accounts for 81% of total dead stock capital**, with 4 of its 5 supplied products now classified as dead stock (80% dead rate).
- The correlation between lead time length and dead stock risk is clear — longer lead times encourage larger buffer orders, and when demand for niche products doesn't materialize, those buffers become dead stock.

> 🔑 **This is not a coincidence — it's a procurement risk pattern.** The `reliability_score` in supplier master data independently rated these two suppliers lowest (72 and 78), and the actual inventory outcome confirms that signal.

### ⚠️ Limitation

This analysis identifies where dead stock exists and which suppliers contributed to it — but it does not provide guidance on preventing future overstocking. That requires understanding optimal replenishment thresholds, which the Reorder Point Analysis addresses next.

---

## 6️⃣ Reorder Point Analysis

### 🔍 Key Findings

- **All 35 products are currently classified as Sufficient Stock** — no product falls below its calculated reorder point, meaning no immediate replenishment action is needed.
- Products with the **highest reorder points** are those with the highest daily demand and/or the longest supplier lead times:
  - Maggi Noodles (PRD023) → **720 units**
  - Paracetamol 500mg (PRD009) → **699 units**
  - Cocola Noodles (PRD022) → **687 units**
- Dead stock and Lifestyle products (PRD031–PRD035) show **reorder points of just 4–6 units** — far below their current stock levels — confirming that replenishment is unnecessary and that existing stock will remain idle without demand recovery.

> 🔑 **Zero reorder alerts is not a passive result — it's a signal.** The company maintains such high buffers across all products that no product is anywhere near needing replenishment. This is directly connected to the low inventory turnover ratios found in the next analysis.

### ⚠️ Limitation

Reorder Point Analysis identifies *when* to reorder — but not *how efficiently* inventory is being used between restocking events. A product can be comfortably above its reorder point while still moving far too slowly. Inventory Turnover Analysis addresses this directly.

---

## 7️⃣ Inventory Turnover Analysis

### 🔍 Key Findings

> **Note:** Turnover was calculated using recent 6-month COGS (annualized) rather than full 24-month COGS. This prevents dead stock products from appearing artificially healthy due to historical sales that occurred before they became inactive.

**Bottom performers — Dead Stock products:**

| Product | Turnover Ratio | Days Inventory Outstanding |
|---|---|---|
| Premium Candle Set | 0.00 | 999 |
| Ceramic Mug Set | 0.00 | 999 |
| Aromatherapy Diffuser | 0.00 | 999 |
| Herbal Bath Salts | 0.00 | 999 |
| Imported Olive Oil | 0.00 | 999 |

**Top performers:**

| Product | Turnover Ratio | Days Inventory Outstanding |
|---|---|---|
| Maggi Noodles 75g | 2.90 | 126 days |
| Cocola Noodles 75g | 2.87 | 127 days |

**By Category:**

| Category | Avg Turnover | Avg DIO |
|---|---|---|
| 🍜 Food & Beverage | 1.54 | 290 days |
| 💊 Healthcare | 1.52 | 242 days |
| 🏠 Home Care | 1.34 | 275 days |
| 🧴 Personal Care | 1.24 | 360 days |
| 🕯️ Lifestyle | 0.00 | 999 days |

- Even the **best-performing active products top out at ~2.9x turnover** — well below the 4–8x range typical for healthy FMCG operations. This is a company-wide signal, not an isolated issue.
- **High revenue ≠ fast inventory movement.** Fresh Soybean Oil generates the most revenue in the portfolio but doesn't rank among the highest-turnover products — capital efficiency and revenue contribution are not the same metric.

> 🔑 **The low turnover across active products — not just dead stock — confirms that the company's procurement approach is systematically buffer-heavy.** Stock levels are consistently higher than what demand patterns require.

### ⚠️ Limitation

Inventory Turnover measures how efficiently inventory converts to sales — but it doesn't explain *why* certain suppliers are associated with worse inventory performance. Supplier Performance Analysis connects the dots.

---

## 8️⃣ Supplier Performance Analysis

### 🔍 Key Findings

**Revenue Contribution by Supplier:**

| Supplier | 🌍 Country | Lead Time | Reliability Score | COGS Contribution |
|---|---|---|---|---|
| Reckitt Benckiser BD | 🇧🇩 Bangladesh | 10 days | 88 | ৳3.29M |
| Unilever BD Ltd | 🇧🇩 Bangladesh | 7 days | 92 | ৳3.15M |
| Pran-RFL Group | 🇧🇩 Bangladesh | 6 days | 90 | ৳3.15M |
| Nestle Bangladesh | 🇧🇩 Bangladesh | 12 days | 87 | ৳2.85M |
| Pacific Imports Ltd | 🇸🇬 Singapore | 28 days | 72 | ৳0.65M |
| Globe Traders (Import) | 🇮🇳 India | 21 days | 78 | ৳1.67M |

**Dead Stock by Supplier:**

| Supplier | Products Supplied | Dead Products | Dead % | Dead Capital |
|---|---|---|---|---|
| Pacific Imports Ltd 🇸🇬 | 5 | 4 | **80%** | **৳61,630** |
| Globe Traders (Import) 🇮🇳 | 3 | 1 | **33.3%** | **৳14,350** |
| All 8 local suppliers 🇧🇩 | 27 | 0 | **0%** | **৳0** |

**Lead Time vs Dead Stock Risk:**

| Supplier Group | Lead Time | Dead Stock |
|---|---|---|
| 🇧🇩 Local (8 suppliers) | 4–12 days | None |
| 🌏 Import (2 suppliers) | 21–28 days | ৳75,980 (100% of total) |

- **The `reliability_score` assigned in master data aligns precisely with actual dead-stock outcomes** — Pacific Imports and Globe Traders had the two lowest reliability scores (72 and 78), and they produced the only dead stock in the portfolio. Two independent data sources confirming the same signal.
- Local suppliers collectively generate the majority of revenue and maintain zero dead stock exposure — a strong case for prioritizing local sourcing for niche or lower-demand product categories.
- Long lead times force larger buffer purchases to avoid stockouts — but when demand for niche products doesn't materialise, those buffers become stranded capital.

> 🔑 **Dead stock is not spread evenly across the supplier network. It is entirely concentrated in 2 of 10 suppliers — both import, both long-lead-time, both low reliability-score.** This is a procurement risk pattern, not a coincidence.

### ⚠️ Limitation

This is an **inventory-focused supplier assessment** — it evaluates lead time, reliability score, and dead stock exposure only. It does not cover purchase price, order fill rate, delivery accuracy, or product quality. A complete supplier evaluation would require additional data sources beyond inventory transactions.

---

## 🔗 How the Analyses Connect

Each analysis answered one question — and revealed the next question to ask:

```
ABC Analysis          → Which products matter most by revenue?
      ↓
XYZ Analysis          → Which products have predictable demand?
      ↓
ABC-XYZ Matrix        → Which products are truly problematic vs. just low-revenue?
      ↓
Stock Aging           → How long has that problematic inventory been sitting?
      ↓
Dead Stock Impact     → Where is the capital locked, and which suppliers caused it?
      ↓
Reorder Point         → Does any product need replenishment right now?
      ↓
Inventory Turnover    → How efficiently is inventory being converted to sales?
      ↓
Supplier Performance  → Which suppliers are driving inventory risk?
```

No single analysis tells the full story. The value comes from layering them.
