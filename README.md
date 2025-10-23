# Amazon Sales Analytics

Comprehensive data anlaytics protfolio analyzing 1000+ Amazon products through SQL, Python, Tableau, NLP, and Machine Learning.

## Overview

This portfolio demonstrates end-to-end data analytics skills through four interconnected projects analyzing Amazon product data:

1. **SQL Analysis:** Product and category performance analysis
2. **Tableau Dashbaord:** Interactive pricing and discount strategy visualization
3. **NLP Sentiment Analysis:** Customer review analysis using Hugging Face

**Dataset:** 1,000+ Amazon products with ratings, reviews, and pricing data

## Project Structure

```
Amazon_sales_analytics/
│
├── data/
│
├── project1/
│
├── project2/
│
├── project3/
│
└── README.md
```

## Projects

### Project 1: Product Perormance Analysis

**Focus:** SQL, Data Analysis, Business Intelligence

#### Key Results 

* Analyzed 1,000+ products using 50+ SQL queries
* Identified Electronics as top performer (4.5 rating, 23% above average)
* Discovered x "hidden gem" products representing $xxk opportunity
* Generated 5 actionable business recommendations

#### Technologies

* MySQL for data analysis
* Python for data processing
* Streamlit for interactive UI

#### SQL Files

| File                            | Description                                               |
| ------------------------------- | --------------------------------------------------------- |
| `00_database_setup.sql`       | Defines schema and indexes                                |
| `01_data_summary.sql`         | Conducts exploratory data profiling                       |
| `02_product_performance.sql`  | Computes product-level KPIs (ratings, reviews, revenue)   |
| `03_category_analysis.sql`    | Analyzes performance by category and subcategory          |
| `04_rating_analysis.sql`      | Examines rating distribution and correlation with pricing |
| `05_comparative_analysis.sql` | Benchmarks top vs. low-performing products and categories |

#### Results

All result screenshots and tables are available under:

* `/results/data_summary_results/`
* `/results/category_analysis_results/`
* `/results/rating_analysis_results/`
* `/results/comparative_analysis_results/`
* `/results/product_performance_results/`

Full report: [`insights.md`](https://github.com/bteze001/Amazon_sales_analytics/blob/main/project1/results/key_findings.md)

## Project 2: Pricing and Discount Strategy Analysis

**Focus:** Tableau Dashboard, KPI Analysis, Satatistical Analysis, Data Visualization

### Overview 

Built an interactive Tableau dashboard analyzing ****pricing tiers** , **discount strategies,** **and their effect on **customer ratings** and **sa****les performance.** 

### **Highlights**

* Compared **discounted vs. non-discounted products**
* Identified **optimal discount range** for maximizing engagement
* Highlighted **price sensitivity** across product tiers (Budget → Premium)
* Created **visual KPI summaries** : Avg. Rating, Discount %, Review Count

Full report: [`insights.md`](https://github.com/bteze001/Amazon_sales_analytics/blob/main/project2/results/insights.md)

## Project 3: Customer Review & Sentiment Analysis

**Focus:** NLP, Text Analytics, VADER, LDA

### **Overview**

Performed sentiment and aspect-based review analysis to understand ****customer satisfaction drivers** and** **product perception.**

### **Methods**

* Tokenized and lemmatized reviews using NLTK
* Used VADER sentiment classification
* Extracted aspects (e.g., “price”, “quality”, “delivery”) for topic modeling

### **Key Insights**

* Sentiment correlates strongly with **rating variance**
* **Delivery** and **durability** drive negative sentiment
* **Ease of use** and **value for money** boost positive feedback

Full report: [`insights.md`](https://github.com/bteze001/Amazon_sales_analytics/blob/main/project2/results/insights.md)
