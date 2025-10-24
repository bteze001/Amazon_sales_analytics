# Project 2: Amazon Pricing & Discount Strategy Analysis

## Overview

Analyzes the impact of pricing strategies and discount levels on customer, revenue distribution, and product perfromance across 1351 Amazon products. Through comprehensive statistical analysis and interactive visualization, we identify optimal pricing tiers and discount ranges that maximize both profitability and customer satisfaction.

**Key Question**: How do discount strategies influence pricing effectiveness and customer perception across different product categories and price tiers?

---

## Objectives

- Evaluate the relationship between discount percentages and customer ratings
- Identify which pricing tiers generate the most revenue
- Determine optimal discount ranges that balance profitability and customer satisfaction
- Analyze category performance and product mix efficiency
- Provide data-driven recommendations for pricing strategy optimization

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
│ ├── correlation_analysis.ipynb
│ ├── statistical_analysis.ipynb
│ └── export_data.ipynb
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

**Database**: MySQL (`amazonSales`)

**Total Products**: 1,351

**Total Revenue**: $828M

### Key Variables

- **Pricing**: `actual_price`, `discounted_price`, `discount_percentage`
- **Quality Metrics**: `rating` (1-5 scale), `rating_count`
- **Classification**: `category`, `price_tier` (Budget/Economy/Mid-Range/Premium/Luxury)
- **Performance**: Calculated revenue and engagement metrics

### Data Quality

- Missing values removed (NULL ratings, prices, review counts excluded)
- Outlier detection applied (IQR method, ~5-8% outliers identified)
- Final clean dataset: 1,351 products

---

## Setup Instructions

1. **Install Python Dependencies**

   ```bash
   pip install pandas numpy matplotlib seaborn scipy mysql-connector-python jupyter
   ```
2. Export Data for Tableau

   Run the notebook:

   ```
   notebooks/export_data.ipynb
   ```

   This generates all requires `.csv`  datasets inside the `/data` folder, formatted for Tableau visualization
3. Run Statistical Analysis

   Execute the analysis notebook:

   **A. Correlation Analysis**

   ```
   notebook/correlation_analysis.ipynb
   ```

* Performs:

  * Pearson correlation (Price vs Rating, Discount vs Rating, Price vs Engagemet)
  * Correlation matrix visualization
  * Category-specific correlations
  * Generates visualizations in `/results`

  **B. Hypothesis Testing**

  ```
  notebook/statistical_tests.ipynb
  ```
* Performs:

  * Independent t-test (Discounted vs Non-discounted products)
  * One-way ANOVA (Ratings across price tiers)
  * Post-hoc pairwise comparisons (Bonferroni correction)
  * Effect size calculations (Cohen's d, Eta-squaared)
  * Generates statistical visualizations

4. View Interactive Tableau Dashboard

   - Open the dahsboard: `result/tableau_dashboard.twbx`
     - Explore visual KPIs such as:
       - Discount Effectiveness
       - Revenue by Price Tier
       - Category Performance
       - Top Performing Products
       - Price vs Rating Engagement
     - **Interactive Controls**:
       - Filter by Price Tier
       - Click revenue bard to filter all charts
       - Hover for detailed tooltips

## Tools & Technologies

| Tool                         | Purpose                                         |
| ---------------------------- | ----------------------------------------------- |
| **Python**             | Data processing, statistical analysis           |
| **Pandas**             | Data manipulation and transformation            |
| **SciPy**              | Statistical tests (t-test, ANOVA, correlations) |
| **Matplotlib/Seaborn** | Statistical visualizations                      |
| **MySQL**              | Database storage and querying                   |
| **Tableau**            | Interactive dashboard creation                  |
| **Juypter Notebook**   | Interactive analysis and documentation          |

## Key Results Summary

### Main Findings

1. **Premium Tier Dominance**

   - 7% of products -> 46% of revenue ($383M)
   - Statistically higher ratings (ANOVA p<0.01)
2. **Optimal Discount Range: 0-25%**

   - Maintains highest ratings (4.15)
   - Deep discounts (60%) shows 2.7% lower ratings
3. **Statistical Validation**

   - Price vs Rating: r = 0.18 (p < 0.05) - weak positive
   - Discount vs Rating: r = -0.15 (p < 0.05) - weak negative
   - T-test: Discounted products differ (p = 0.032)
   - ANOVA: Significant tier differences (F = 18.45, p < 0.001)
4. **Category Risk**

   - Electronics: 92% revenur concentration
   - Diversification recommended

   **For detailed analysis, statistical validation, and comprehensive recommendations, see: [`insights.md`](https://github.com/bteze001/Amazon_sales_analytics/blob/main/project2/results/insights.md)**

## Skills Demonstrated 

- SQL data extraction and transformation
- Statistical hypothesis testing
- Correlation analysis and interpretation
- Data visualization
- Business analytics
- Technical documentation and reporting
