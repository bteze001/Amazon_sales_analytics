use amazonSales;

-- ============================================
-- SECTION 1: OVERALL PRICE DISTRIBUTION
-- ============================================

-- 1.1: Price Summary Statistics 
SELECT 
    'Price Statistics' as metrics,
    COUNT(*) as total_products,
    CONCAT('$', ROUND(MIN(discounted_price), 2)) as min_price,
    CONCAT('$', ROUND(MAX(discounted_price), 2)) as max_price,
    CONCAT('$', ROUND(AVG(discounted_price), 2)) as avg_price,
    CONCAT('$', ROUND(STDDEV(discounted_price), 2)) as std_dev
FROM products
WHERE discounted_price IS NOT NULL;

-- 1.2:  Price distribution by buckets 

SELECT 
    CASE
        WHEN dicounted_price <= 10 THEN '$0-10'
        WHEN discounted_price <= 25 THEN '$11-25'
        WHEN discounted_price <= 50 THEN '$26-50'
        WHEN discounted_price <= 100 THEN '$51-100'
        WHEN discounted_price <= 250 THEN '$101-250'
        WHEN discounted_price <= 500 THEN '$251-500'
        WHEN discounted_price <= 1000 THEN '$501-1000'
        ELSE '$1000+'
    END as price_buckets,
    COUNT(*) as product_count,
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY price_buckets
ORDER_BY product_count;

-- ============================================
-- SECTION 2: PRICE TIER ANALYSIS
-- ============================================

-- 2.1: Performance by price tier

SELECT 
    CASE 
        WHEN discounted_price < 10 THEN '1-Budget'
        WHEN discounted_price < 50 THEN '2-Economy'
        WHEN discounted_price < 100 THEN '3-Mid-Range'
        WHEN discounted_price < 500 THEN '4-Premium'
        ELSE '5-Luxury'
    END as price_tier,
    COUNT(*) as product_count,
    CONCAT('$', MIN(discounted_price), '- $', MAX(discounted_price)) as price_range,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(discount_percentage), 1) as avg_discount_percentage
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY price_tier
ORDER BY price_tier;

-- ============================================
-- SECTION 3: CATEGORY PRICING ANALYSIS
-- ============================================

-- 3.1: Price Statistics By Category 

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    CONCAT('$', ROUND(AVG(discounted_price)), 2) as avg_price,
    CONCAT('$', ROUND(MIN(discounted_price)), 2) as min_price,
    CONCAT('$', ROUND(MAX(discounted_price)), 2) as max_price,
    ROUND(STDDEV(discounted_price), 2) as std_dev
FROM products
WHERE category IS NOT NULL AND discounted_price IS NOT NULL
GROUP BY main_category
HAVING products >= 3
ORDER BY AVG(discounted_price) DESC;

-- 3.2: Price-Rating Correlation by category 

/* 
Calculating the Pearson correlation coefficent between price and rating for each 
category to answer: "Do higher-priced products get better ratings in this category?" 
*/
-- PRICE AND DISCOUNT ANALYSIS
-- ============================================

-- Average discount per category 

SELECT 
    category, 
    AVG(actual_price - discounted_price) as avg_discount_price,
    AVG(discount_percentage) as avg_discount_percentage
    COUNT(*) as product_count
FROM products
GROUP BY category
ORDER BY avg_discount_price DESC

-- Max and min discounted price per category 

-- Products with highest discount percentage 

-- Correlation check: high discount vs high rating

