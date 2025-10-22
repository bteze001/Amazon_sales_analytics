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
├── pricing_insights.md
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

   - Run export_data.ipynb notebook to create all the .csv files under the `/data` folder.
3. Run Statistical Analysis

   - Open notebooks/statistical_analysis.ipynb to run:
     - Descriptive statistics
     - Two-sample t-tests
     - Correlation analysis
4. View Tableau Dashboard

   - Open the amazon_pricing_dashboard.twbx to explore the visual insights

## Tools Used 

* Python

  - Pandas
  - Matplitlib
  - Seaborn
  - numpy
  - MySQL connector ...
* MySQL
* Tableau
