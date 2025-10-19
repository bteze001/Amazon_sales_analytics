use amazonSales;

/*
============================================
 SECTION 1: OVERALL PRICE DISTRIBUTION
============================================
*/

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

-- 1.2: Price distribution by buckets 

SELECT 
    CASE
        WHEN discounted_price <= 10 THEN '$0-10'
        WHEN discounted_price <= 25 THEN '$11-25'
        WHEN discounted_price <= 50 THEN '$26-50'
        WHEN discounted_price <= 100 THEN '$51-100'
        WHEN discounted_price <= 250 THEN '$101-250'
        WHEN discounted_price <= 500 THEN '$251-500'
        WHEN discounted_price <= 1000 THEN '$501-1000'
        ELSE '$1000+'
    END as price_buckets,
    COUNT(*) as product_count
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY price_buckets
ORDER BY product_count;


/* 
============================================
SECTION 2: PRICE TIER ANALYSIS
============================================
*/

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
    CONCAT('$', ROUND(MIN(discounted_price), 2), '- $', ROUND(MAX(discounted_price), 2)) as price_range,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(discount_percentage), 1) as avg_discount_percentage
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY price_tier
ORDER BY price_tier;
 
-- 2.2: Revenue potential by tier
SELECT 
    CASE 
        WHEN discounted_price < 10 THEN '1-Budget'
        WHEN discounted_price < 50 THEN '2-Economy'
        WHEN discounted_price < 100 THEN '3-Mid-Range'
        WHEN discounted_price < 500 THEN '4-Premium'
        ELSE '5-Luxury'
    END as price_tier,
    COUNT(*) as products,
    CONCAT('$', ROUND(SUM(discounted_price * rating_count), 2)) as estimated_revenue,
    CONCAT('$', ROUND(AVG(discounted_price * rating_count), 2)) as avg_revenue_per_product,
    ROUND(SUM(discounted_price * rating_count) * 100.0 / 
          (SELECT SUM(discounted_price * rating_count) FROM products WHERE discounted_price IS NOT NULL), 1) as revenue_share_pct
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY price_tier
ORDER BY SUM(discounted_price * rating_count) DESC;

/* 
============================================
SECTION 3: CATEGORY PRICING ANALYSIS
============================================
*/

-- 3.1: Price Statistics By Category 

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    CONCAT('$', ROUND(AVG(discounted_price), 2)) as avg_price,
    CONCAT('$', ROUND(MIN(discounted_price), 2)) as min_price,
    CONCAT('$', ROUND(MAX(discounted_price), 2)) as max_price,
    ROUND(STDDEV(discounted_price), 2) as std_dev
FROM products
WHERE category IS NOT NULL AND discounted_price IS NOT NULL
GROUP BY main_category
HAVING product_count >= 3
ORDER BY AVG(discounted_price) DESC;

-- 3.2: Price range by category 

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    CONCAT('$', ROUND(AVG(discounted_price), 2)) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount_percentage
FROM products
WHERE discounted_price IS NOT NULL
GROUP BY main_category
ORDER BY MIN(discounted_price);

-- 3.3: Most expensive category 

SELECT 
    main_category,
    product_name AS most_expensive_product,
    CONCAT('$', ROUND(max_price, 2)) AS highest_price,
    product_count,
    CONCAT('$', ROUND(avg_price, 2)) AS category_avg_price
FROM (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) AS main_category,
        p.product_name,
        p.discounted_price,
        COUNT(*) OVER (PARTITION BY SUBSTRING_INDEX(category, '|', 1)) AS product_count,
        AVG(p.discounted_price) OVER (PARTITION BY SUBSTRING_INDEX(category, '|', 1)) AS avg_price,
        MAX(p.discounted_price) OVER (PARTITION BY SUBSTRING_INDEX(category, '|', 1)) AS max_price,
        ROW_NUMBER() OVER (PARTITION BY SUBSTRING_INDEX(category, '|', 1) ORDER BY p.discounted_price DESC) AS rn
    FROM products p
    WHERE category IS NOT NULL 
      AND discounted_price IS NOT NULL
) ranked
WHERE rn = 1
ORDER BY max_price DESC
LIMIT 10;


-- 3.3: Price-Rating Correlation by category 

/* 
Calculating the Pearson correlation coefficent between price and rating for each 
category to answer: "Do higher-priced products get better ratings in this category?" 
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as products,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(rating), 2) as avg_rating,
    -- Pearson correlation coefficient
    ROUND(
        (COUNT(*) * SUM(discounted_price * rating) - SUM(discounted_price) * SUM(rating)) / 
        SQRT(
            (COUNT(*) * SUM(discounted_price * discounted_price) - SUM(discounted_price) * SUM(discounted_price)) * 
            (COUNT(*) * SUM(rating * rating) - SUM(rating) * SUM(rating))
        ), 
    3) as price_rating_correlation,
    -- Interpretation
    CASE 
        WHEN (COUNT(*) * SUM(discounted_price * rating) - SUM(discounted_price) * SUM(rating)) / 
             SQRT((COUNT(*) * SUM(discounted_price * discounted_price) - SUM(discounted_price) * SUM(discounted_price)) * 
                  (COUNT(*) * SUM(rating * rating) - SUM(rating) * SUM(rating))) > 0.5 
        THEN 'Strong Positive (Premium pricing works)'
        WHEN (COUNT(*) * SUM(discounted_price * rating) - SUM(discounted_price) * SUM(rating)) / 
             SQRT((COUNT(*) * SUM(discounted_price * discounted_price) - SUM(discounted_price) * SUM(discounted_price)) * 
                  (COUNT(*) * SUM(rating * rating) - SUM(rating) * SUM(rating))) > 0.3 
        THEN 'Moderate Positive'
        WHEN (COUNT(*) * SUM(discounted_price * rating) - SUM(discounted_price) * SUM(rating)) / 
             SQRT((COUNT(*) * SUM(discounted_price * discounted_price) - SUM(discounted_price) * SUM(discounted_price)) * 
                  (COUNT(*) * SUM(rating * rating) - SUM(rating) * SUM(rating))) < -0.3 
        THEN 'Negative (Quality issues!)'
        ELSE 'No correlation'
    END as interpretation
FROM products
WHERE category IS NOT NULL
  AND discounted_price IS NOT NULL
  AND rating IS NOT NULL
GROUP BY main_category
HAVING products >= 5
ORDER BY price_rating_correlation DESC;

/*
============================================
SECTION 4: PRICE AND DISCOUNT ANALYSIS
============================================
*/

-- 4.1: Average discount per category 
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    CONCAT('$', ROUND(AVG(actual_price - discounted_price), 2)) as avg_discount_amount,
    ROUND(AVG(discount_percentage), 1) as avg_discount_percentage,
    CONCAT('$', ROUND(SUM(actual_price - discounted_price), 2)) as total_savings_offered
FROM products
WHERE category IS NOT NULL
  AND actual_price IS NOT NULL
  AND discounted_price IS NOT NULL
GROUP BY main_category
HAVING product_count >= 3
ORDER BY AVG(actual_price - discounted_price) DESC;

-- 4.2: Max and min discounted price per category 
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as products,
    CONCAT('$', ROUND(MIN(discounted_price), 2)) as cheapest_product,
    CONCAT('$', ROUND(MAX(discounted_price), 2)) as most_expensive_product,
    CONCAT('$', ROUND(MAX(discounted_price) - MIN(discounted_price), 2)) as price_spread
FROM products
WHERE category IS NOT NULL
  AND discounted_price IS NOT NULL
GROUP BY main_category
HAVING products >= 3
ORDER BY MAX(discounted_price) - MIN(discounted_price) DESC;

-- 4.3: Products with highest discount percentage 
SELECT 
    product_id,
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    CONCAT('$', ROUND(actual_price, 2)) as original_price,
    CONCAT('$', ROUND(discounted_price, 2)) as sale_price,
    CONCAT('$', ROUND(actual_price - discounted_price, 2)) as savings,
    ROUND(discount_percentage, 1) as discount_pct,
    rating,
    rating_count
FROM products
WHERE discount_percentage > 0
ORDER BY discount_percentage DESC
LIMIT 20;

-- 4.4: Correlation check: High discount vs High rating
SELECT 
    CASE 
        WHEN discount_percentage = 0 THEN 'No Discount'
        WHEN discount_percentage <= 25 THEN 'Light (1-25%)'
        WHEN discount_percentage <= 40 THEN 'Moderate (26-40%)'
        WHEN discount_percentage <= 60 THEN 'Heavy (41-60%)'
        ELSE 'Extreme (60%+)'
    END as discount_tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_review_count,
    -- Check if heavily discounted products have lower ratings
    CASE 
        WHEN AVG(rating) < 4.0 THEN '⚠️ Below Average'
        WHEN AVG(rating) < 4.2 THEN 'Average'
        ELSE '✓ Good'
    END as quality_perception
FROM products
WHERE discount_percentage IS NOT NULL
  AND rating IS NOT NULL
GROUP BY discount_tier
ORDER BY FIELD(discount_tier, 'No Discount', 'Light (1-25%)', 'Moderate (26-40%)', 'Heavy (41-60%)', 'Extreme (60%+)');


/*
============================================
SECTION 5: UNDERPRICED/OVERPRICED ANALYSIS
============================================
*/

-- 5.1: Identify underpriced products (potential to raise prices)
WITH category_avg AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(discounted_price) as avg_category_price
    FROM products
    WHERE discounted_price IS NOT NULL
    GROUP BY main_category
)
SELECT 
    p.product_id,
    p.product_name,
    SUBSTRING_INDEX(p.category, '|', 1) as main_category,
    CONCAT('$', ROUND(p.discounted_price, 2)) as current_price,
    CONCAT('$', ROUND(c.avg_category_price, 2)) as category_avg,
    CONCAT('$', ROUND(c.avg_category_price - p.discounted_price, 2)) as price_gap,
    ROUND(((c.avg_category_price - p.discounted_price) / p.discounted_price) * 100, 1) as pct_below_avg,
    p.rating,
    p.rating_count,
    -- Potential revenue increase
    CONCAT('$', ROUND((c.avg_category_price - p.discounted_price) * p.rating_count * 0.1, 2)) as estimated_opportunity
FROM products p
JOIN category_avg c ON SUBSTRING_INDEX(p.category, '|', 1) = c.main_category
WHERE p.discounted_price < c.avg_category_price * 0.7  -- 30% below average
  AND p.rating >= 4.0  -- Good quality
  AND p.rating_count >= 50  -- Proven product
ORDER BY (c.avg_category_price - p.discounted_price) * p.rating_count DESC
LIMIT 20;

-- 5.2: Identify overpriced products (potential to lower prices)
WITH category_avg AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(discounted_price) as avg_category_price,
        AVG(rating) as avg_category_rating
    FROM products
    WHERE discounted_price IS NOT NULL
    GROUP BY main_category
)
SELECT 
    p.product_id,
    p.product_name,
    SUBSTRING_INDEX(p.category, '|', 1) as main_category,
    CONCAT('$', ROUND(p.discounted_price, 2)) as current_price,
    CONCAT('$', ROUND(c.avg_category_price, 2)) as category_avg,
    CONCAT('$', ROUND(p.discounted_price - c.avg_category_price, 2)) as price_premium,
    ROUND(((p.discounted_price - c.avg_category_price) / c.avg_category_price) * 100, 1) as pct_above_avg,
    p.rating,
    ROUND(c.avg_category_rating, 2) as category_avg_rating,
    p.rating_count,
    CASE 
        WHEN p.rating < c.avg_category_rating THEN '⚠️ Lower price recommended'
        ELSE 'Premium justified'
    END as recommendation
FROM products p
JOIN category_avg c ON SUBSTRING_INDEX(p.category, '|', 1) = c.main_category
WHERE p.discounted_price > c.avg_category_price * 1.3  -- 30% above average
  AND p.rating < 4.5  -- Not exceptional quality
ORDER BY (p.discounted_price - c.avg_category_price) DESC
LIMIT 20;

