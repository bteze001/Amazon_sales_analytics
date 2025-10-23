# Product Performance Analysis Results Report

## 1. Objective

The goal of this analysis is to evaluate **product performance across different categories** using SQL-based data analytics.
Through exploratory queries and comparative metrics, this study aims to:

* Identify **top-performing products and categories**
* Understand how **ratings, price, and discounts** influence performance
* Detect **hidden opportunities** such as underrated high-quality products
* Provide data-backed recommendations for **portfolio optimization**

## 2. Data Overview

| Attribute            | Description                                                 |
| -------------------- | ----------------------------------------------------------- |
| **Source**     | Amazon Product Sales Dataset                                |
| **Key Fields** | Product ID, Category, Rating, Price, Discount, Review Count |
| **Tools Used** | MySQL for analysis, Python for automation and reporting     |
| **Volume**     | ~XX,XXX products, XX categories, XX,XXX total reviews       |

## 3. Analysis Pipeline

The project consists of several SQL modules:

| Step | File                            | Description                                                         |
| ---- | ------------------------------- | ------------------------------------------------------------------- |
| 1    | `00_database_setup.sql`       | Creates database schema and tables                                  |
| 2    | `01_data_preprocessing.sql`   | Cleans and imports raw product data                                 |
| 3    | `02_product_performance.sql`  | Calculates product-level metrics such as sales volume and revenue   |
| 4    | `03_category_analysis.sql`    | Evaluates category-level performance and average ratings            |
| 5    | `04_rating_analysis.sql`      | Analyzes product rating distribution and correlation with price     |
| 6    | `05_comparative_analysis.sql` | Compares top-performing vs. underperforming products and categories |

## 4. Key Insights


### **4.1 Data Health and Completeness (`data_summary.sql`)**

* **Total Products:** *[insert number]*
* **Total Users:** *[insert number]*
* **Total Reviews:** *[insert number]*
* **Null Values:** None detected across major tables (clean dataset ✅)

**Distribution Overview:**

| Metric   | Mean            | Median                                  | Notes                                    |
| -------- | --------------- | --------------------------------------- | ---------------------------------------- |
| Price    | $X.XX | $X.XX | Moderate skew due to premium categories |                                          |
| Rating   | X.XX            | X.XX                                    | Ratings cluster around 4.2–4.5          |
| Discount | X%              | X%                                      | Discounts mainly found in mid-tier items |

**Interpretation:**
The dataset is well-structured and balanced, suitable for performance benchmarking. No major missing data issues were detected.

### **4.2 Product-Level Insights (`product_performance_analysis.sql`)**

* **Top 10 Highest Rated Products:** Predominantly from** ***[Category]* with ratings ≥4.8 and strong review volume.
* **Hidden Gems:** Identified several low-review but high-rating products (e.g., niche tech accessories).
* **Premium vs. Value Segments:**
  * Premium products show** ****high engagement** but** ** **slightly lower average ratings** .
  * Budget products have** ** **lower visibility** , yet some achieve competitive ratings.

**Bayesian Adjustment:**
After applying a weighted rating formula, product rankings slightly shift, revealing more stable performers.

### **4.3 Category Insights (`category_analysis.sql`)**

| Metric                  | Category                          | Observation                       |
| ----------------------- | --------------------------------- | --------------------------------- |
| Highest Engagement      | **Electronics**             | Avg. 28,997 reviews per product   |
| 2nd Highest             | **Computers & Accessories** | Avg. 16,894 reviews per product   |
| Best Rated (avg. ≥4.7) | **Books / Office Supplies** | Consistent satisfaction           |
| Most Volatile           | **Fashion & Apparel**       | Wide range of reviews and ratings |

**Interpretation:**
High-engagement categories tend to dominate product visibility. However, categories like Books and Home Essentials maintain exceptional satisfaction even at lower price points.

### **4.4 Rating Behavior (`rating_analysis.sql`)**

* **Distribution:** Ratings heavily concentrated between 4–5 stars.
* **Outliers:** Several products show** ***perfect 5.0 ratings* with high volume → may indicate review bias.
* **Category Consistency:** Tech-related products show the** ****lowest variance** (stable perception), while lifestyle items fluctuate more.
* **Correlation:** A weak positive correlation between** ** **price and rating** , suggesting higher price does not always equal higher satisfaction.

### **4.5 Comparative Insights (`comparative_analysis.sql`)**

| Segment                | Performance        | Observation                                         |
| ---------------------- | ------------------ | --------------------------------------------------- |
| Top 10% of Products    | Excellent          | Balanced price, high engagement, stable ratings     |
| Bottom 10%             | Underperforming    | Overpriced or inconsistent quality                  |
| High Discount Products | Mixed Results      | Some show increased engagement, others poor ratings |
| Category Leaders       | Electronics, Books | Strong overall performance                          |
| Laggards               | Apparel, Sports    | Inconsistent engagement                             |

**Interpretation:**
Discount strategies and price tiers influence perception but not always positively — the key differentiator is** ****rating reliability** and** ** **consistent engagement** .

## **5. Visual & Output References**

Screenshots and data exports are available under:

* `/results/data_summary_results/` – Summary statistics and completeness checks
* `/results/category_analysis_results/` – Category breakdowns and performance tiers
* `/results/product_performance_results/` – Individual product KPIs and rankings
* `/results/rating_analysis_results/` – Distribution and correlation plots
* `/results/comparative_analysis_results/` – Cross-category benchmarking visuals

## **6. Conclusion**

This analysis highlights how **ratings, engagement, and pricing strategies** jointly shape product performance.
Future work may include:

* Integrating time-series sales data for trend forecasting
* Using machine learning to predict future bestsellers
* Automating dashboards for continuous performance tracking

## 7. Deliverables

* `insights.md` – This report
* `key_findings.md` – Concise bullet summary
* SQL scripts – Modular queries for reproducibility
* Screenshots – Stored under** **`/results/screenshots/`
