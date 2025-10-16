# Project 1: Amazon Product & Category Performace Analysis

## Objective

Analyze 1000+ Amazon products to identify top-performing products and categories based on ratings, reviews, and engagement metrics.

## Dataset

- **Size:** 1000+ products
- **Features:** 17 columns including product info, pricing, ratings, reviews
- **Source:** https://www.kaggle.com/datasets/karkavelrajaj/amazon-sales-dataset

## Key Questions

1. Which product have the highest ratings?
2. Which categories perform best?
3. What's the distribution of ratings across products?
4. How do rating counts correlate with product ratings?
5. Which categories have the most engagement?
6. What are the hidden gem products?
7. Which products are underperforming?

## Tools & Technologies

- **MySQL**: Database management and SQL queries
- **Python**: Data celaning and preprocessing

## Project Structure

```
project1/
│
├── README.md  
│
├── data_processing/
│   └── clean_data.py
│
├── sql/
│   ├── 00_database_setup.sql   
│   ├── 01_data_summary.sql  
│   ├── 02_product_performance.sql  
│   ├── 03_category_analysis.sql   
│   ├── 04_rating_analysis.sql  
│   └── 05_comparative_analysis.sql   
│
├── results/
│   ├── screenshots/       
│   ├── findings/             
│   └── exports/                
│
└── UI/
    └── project1_UI.py           
```

## How to Run

**Step 1: Download Data**

```
https://www.kaggle.com/datasets/karkavelrajaj/amazon-sales-dataset
```

**Step 2: Clean Data**

```
cd data_preprocessing
python3 clean_data.py
```

**What this does:**

**Step 3: Set Up Database and load data**

```
mysql -u root -p
source sql/00_database_setup.sql
```

**Step 5: Run Analysis Queries**

```
mysql -u root -p amazonSales < sql/01_data_summary.sql
mysql -u root -p amazonSales < sql/02_product_performance.sql
mysql -u root -p amazonSales < sql/03_category_analysis.sql
mysql -u root -p amazonSales < sql/04_rating_analysis.sql
mysql -u root -p amazonSales < sql/05_comparative_analysis.sql
```

**Step 6: View Results**

```
cd results 
ls -l
```

**Step 7: Launch Interactive Dashboard**

```
cd UI
python3 project1_UI
```

## SQL Analysis Files

### 00_database_setup.sql

**Purpose: Initalize database and create optimized table structure**

**Contents:**

* Database creation (`amazonSales`)
* Table schema with appropriate data types
* Index creation for query optimization
* Initial validation queries

**Run Time:** ~2-3 minutes (including data load)

### 01_data_summary.sql

**Purpose: Exploratory data analysis and data quality checks**

**Sections:**

1. Data Overview: Row counts, column info
2. Data Quality: Null Values, duplicates
3. Basic Statistics: Average, min/max, distributions
4. Category Distribution: Product counts by category
5. Price Analysis: Price ranges and statistics

### 02_product_performance.sql

**Purpose: Analyze individual product performance**

**Total Queries:** 24

**Key Analyses:**

1. **Top Performers**
   * Highest-rated products
   * Most reviewed products
   * Best value products
2. **Product Segmentation**
   * By price tier
   * By rating tier
   * By engagement tier
3. **Performance Metrics**
   * Value for money scoring
   * Rating review correlation
   * Price performance analysis

**Sample Output:**

### 03_Category_analysis.sql

**Purpose: Category level performance evaluation**

**Total Queries:** 18

**Key Analyses:**

1. **Category Overview**
   * Product counts per category
   * Average metrics by category
   * Category performance rankings
2. **Category Performance Matrix**
   * Rating vs engagement mapping
   * Price positioning by category
   * Discount strategies
3. **Top/Bottom Categories**
   * Best performing categories
   * Underperforming categories
   * Category opportunities

**Answers Question: Which categories perform best?**

### 04_rating_analysis.sql

**Purpose: Rating patterns and correlations analysis**

**Total Queries**: 19

**Key Analyses:**

1. **Rating Distribution**
   * Overall rating spread
   * Rating histogram
   * Percentile analysis
2. **Review Volume Analysis**
   * High vs low engagement products
   * Review distribution patterns
   * Viral products identification
3. **Correlation Analysis**
   * Rating vs review count correlation
   * Rating vs price relationship
   * Rating vs discount effectiveness

**Answers Question:**

### 05_comparative_analysis.sql

**Purpose:**

**Sections:**

## Key Findings

#### Top Performing Products

* **Highest Rated**:
  * **Product:** Swiffer Instant Electric Water Heater
  * **Rating:** 4.8
  * **Reviews:** 53803
  * **Price:** $17.27
  * **Category:** InstantWaterHeaters
* **Most Reviewed**:
  * **Product:** AmazonBasics Flexible Premium HDMI Cable
  * **Rating:** 4.4
  * **Reviews:** 426973
  * **Price:** $3.71
  * **Category:** HDMICables
* **Best Value**:
  * **Product:** Classmate Octane Neon- Blue Gel Pens(Pack of 5)
  * **Rating:** 4.3
  * **Reviews:** 5792
  * **Price:** $0.60
  * **Category:** OfficeProducts

#### Category Performance

* **Top Category**: **OfficeProducts**
  * **Average Rating:** 4.31
  * **Total Reviews:** 149675
  * **Performance:**
* **Most Engaged Category: Electronics**
  * **Total Reviews:** 14,208,400
  * **Products:** 490
  * **Avg Reviews per Products:** 28997
  * **Insight:** High customer interaction
* **Best Value Category: OfficeProducts**
  * **Avg Rating:**
  * **Avg Price:**
  * **Insight:** Strong quality at compettivie prices

#### Rating Distribution

* **Average Rating:** 4.09
* **Standard Deviation:** 0.32
* **Rating Breakdown:**
  * **5.0 stars:** 3
  * **4.5 - 4.9 stars:** 93
  * **40-4.4 stars:** 914
  * **3.0 - 4.0 stars:** 334
  * **2.0 - 3.0 stars:** 6
  * **Under 1.0 stars:** 1
* **Insight:** Portfolio skewed toward high quality

## Related Projects 

*  ******[**Project 2: Pricing and Discount Strategy Analysis**](**[../project2/README.md](https://github.com/bteze001/Amazon_sales_analytics/tree/main/project2#readme)**)****** - Tableau visualization and statistical analysis
* [**Project 3: Customer Review & Sentiment Analys**](**../project3/README.md**) - NLP-based review analysis
