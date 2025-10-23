# Project 2: Amazon Pricing & Discount Strategy Analysis

## Objective

Analyze pricing strategies and discount effectiveness to identify optimal pricing and discount levels for maximizing ratings and revenue.

This project analyzes the impact of pricing and discount strategies on product ratings, revenue distribution, and customer perception.

It combines **statistical analysis in Python** and **interactive data visualization in Tableau** to identify optimal pricing tiers and discount levels for maximizing profitability and satisfaction.

---

## Project Structure

```
├── data/
│ ├── tableau_main_products.csv
│ ├── tableau_revenue_by_tier.csv
│ ├── tableau_discount_effectiveness.csv
│ ├── tableau_category_performance.csv
│ ├── tableau_price_engagement.csv
│ ├── tableau_top_performers.csv
│ └── tableau_kpi_summary.csv
│
├── notebooks/
│ ├──correlation_analysis.ipynb
│ ├──statistical_analysis.ipynb
│ └──export_data.ipynb
│
├── result/
│ ├── visualizations/
│ │ ├──screenshots/
│ └── amazon_pricing_dashboard.twbx 
│
├── insights.md
└── README.md # Project Overview & Instructions
```

---

## Data Source

Data is extracted from a MySQL database named `amazonSales`, containing product-level information such as:

- `actual_price`, `discounted_price`, `discount_percentage`
- `rating`, `rating_count`
- `category`
- Computed fields like `revenue`, `price_tier`, and `discount_range`

---

## Setup Instructions

1. **Install Dependencies**

   ```bash
   pip install pandas mysql-connector-python
   ```
2. Export Data for Tableau

   Run the notebook:

   ```
   notebooks/export_data.ipynb
   ```

   This generates all requires `.csv`  datasets inside the `/data` folder, formatted for Tableau visualization
4. Run Statistical Analysis

    `notebooks/statistical_analysis.ipynb `

* This notebook performs:
  * Descriptive statistics
  * Two-sample **t-tests** (discounted vs non-discounted)
  * **ANOVA** (rating comparison across price tiers)
  * **Effect size (Cohen’s d)** calculations
  * Visualizations of rating distributions

4. View Tableau Dashboard

   - Open the interactive dahsboard: `result/tableau_dashboard.twbx`
     - Explore visual KPIs such as:
       - Discount Effectiveness
       - Revenue by Price Tier
       - Category Performance
       - Top Performing Products
       - Price vs Rating Engagement

## Tools Used

* Python

  - Pandas
  - Matplitlib / Seaborn
  - numpy
  - MySQL connector
  - scipy.stats
* Database

  * MySQL
* Visualization

  * Tableau

## Key Results Summary

* **T-Test:** `t ≈ -3.297`, `p ≈ 0.001` → Statistically significant difference in ratings between discounted and non-discounted products.
* **ANOVA:** Significant differences across price tiers —** ***Premium* and** ***Mid-Range* outperform others.
* **Optimal Discount Range:** *0–40%* yields highest ratings and engagement.
* **Revenue Distribution:** *Premium* products represent ~7% of listings but generate ~46% of revenue.

Full interpretation available in:
📄[`Insights.md`](pricing_insights.md)
