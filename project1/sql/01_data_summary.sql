USE amazonSales;

/* 
============================================
SECTION 1: DATABASE STRUCTURE OVERVIEW
============================================
Purpose: Understand what tables and columns we have
*/

-- 1.1: Total product
SELECT COUNT(*) as product_count
FROM products;

-- 1.2: Total users
SELECT COUNT(*) as user_count
FROM users;

-- 1.3: Total reviews 
SELECT COUNT(*) as review_count
FROM reviews;

/*
============================================
SECTION 2: DATA COMPLETENESS CHECK
============================================
Purpose: Identify missing data (NULLs) that could affect analysis
*/

-- 2.1: Null values in the products table 
SELECT 
    COUNT(*) AS total_products_rows,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_name IS NULL  OR product_name = '' THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN category IS NULL or category = '' THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN discounted_price IS NULL THEN 1 ELSE 0 END) AS null_discount,
    SUM(CASE WHEN actual_price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN discount_percentage IS NULL THEN 1 ELSE 0 END) AS null_percentage,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN rating_count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM products;

-- 2.2: Null values in the users table
SELECT 
    COUNT(*) AS total_users_rows,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_usr_id,
    SUM(CASE WHEN user_name IS NULL OR user_name = '' THEN 1 ELSE 0 END) AS null_user_name
FROM users;


-- 2.3: Null values in the reviews table 
SELECT 
    COUNT(*) AS total_reviews_rows,
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS null_review_id,
    SUM(CASE WHEN user_id IS NULL OR user_id = '' THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN review_title IS NULL OR review_title = '' THEN 1 ELSE 0 END) AS null_review_title,
    SUM(CASE WHEN review_content IS NULL OR review_content = '' THEN 1 ELSE 0 END) AS null_review_content
FROM reviews;

/*
============================================
SECTION 3: UNIQUE VALUE COUNTS
============================================
Purpose: Understand data cardinality and relationships
*/

-- 3.1: Unique Product Count

SELECT 
    COUNT(DISTINCT(product_id)) as unique_products,
    COUNT(DISTINCT(product_name)) as unique_product_name,
    COUNT(DISTINCT(category)) as unique_categories
FROM products;

-- 3.2: Unique Users Count
SELECT COUNT(DISTINCT(user_id)) as unique_users
FROM users;

SELECT COUNT(DISTINCT(review_id)) as unique_reviews
FROM reviews;

-- 3.3: Total unique categories count
SELECT COUNT(DISTINCT category) as total_categories
FROM products;

-- 3.4: Products per category 
SELECT 
    category,
    COUNT(*) AS product_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products), 2) AS pct_of_total
FROM products
GROUP BY category
ORDER BY product_count DESC
LIMIT 10;

/* 
============================================
SECTION 4: NUMERIC COLUMN STATISTICS
============================================
Purpose: Understand range and distribution of numeric data
*/

-- 4.1: Price and Discount Statistics

SELECT 
    'Discounted Price' AS price_type,
    MIN(discounted_price) AS min_price,
    MAX(discounted_price) AS max_price,
    AVG(discounted_price) AS avg_price
FROM products
WHERE discounted_price IS NOT NULL
UNION ALL
SELECT 
    'Actual Price',
    MIN(actual_price),
    MAX(actual_price),
    AVG(actual_price)
FROM products
WHERE actual_price IS NOT NULL
UNION ALL 
SELECT 'Discount Percentage',
    MIN(discount_percentage),
    MAX(discount_percentage),
    AVG(discount_percentage)
FROM products
WHERE discount_percentage IS NOT NULL;

-- 4.2: Rating Count Statistics 

SELECT 
    MIN(rating_count) AS min_rating_count,
    MAX(rating_count) AS max_rating_count,
    AVG(rating_count) AS avg_rating_count,
    COUNT(CASE WHEN rating_count = 0 THEN 1 END) AS products_with_no_ratings,
    COUNT(CASE WHEN rating_count > 0 THEN 1 END) AS products_with_ratings
FROM products;

/*
============================================
SECTION 5: DISTRIBUTION ANALYSIS
============================================
Purpose: See how data is distributed across ranges
*/

-- 5.1: Price breakdown

SELECT 
    CASE
        WHEN discounted_price < 50 THEN 'Under $50'
        WHEN discounted_price < 100 THEN '$50-100'
        WHEN discounted_price < 500 THEN '$100-500'
        WHEN discounted_price < 1000 THEN '$500-$1000'
        ELSE 'OVER $1000'
    END AS price_range,
    COUNT(*) AS product_count
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY price_range
ORDER BY MIN(discounted_price);

-- 5.2: Rating breakdown 

SELECT 
    CASE
        WHEN rating >= 4.5 THEN '4.5-5.0 (Excellent)'
        WHEN rating >= 4.0 Then '4.0-4.4 (Very Good)'
        WHEN rating >= 3.5 THEN '3.5-3.9 (Good)'
        WHEN rating >= 3.0 THEN '3.0-3.4 (Average)'
        WHEN rating >= 2.0 THEN '2.0-2.9 (Below Average)'
        ELSE '0-1.9(Poor)'
    END as rating_range,
    COUNT(*) as product_count
FROM products
WHERE rating IS NOT NULL
GROUP BY rating_range
ORDER BY MIN(rating) DESC;

-- 5.3: Discount breakdown 

SELECT 
    CASE
        WHEN discount_percentage = 0 THEN 'No Discount'
        WHEN discount_percentage < 10 THEN '1-9%'
        WHEN discount_percentage < 25 THEN '10-24%'
        WHEN discount_percentage < 50 THEN '25-49%'
        WHEN discount_percentage < 75 THEN '50-74%'
        ELSE '75%+'
    END AS discount_range,
    COUNT(*) as product_count
FROM products
WHERE discount_percentage IS NOT NULL
GROUP BY discount_range
ORDER BY MIN(discount_percentage);









