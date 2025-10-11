/*
============================================
FILE: 05_comparative_analysis.sql
PURPOSE: Compare products, categories, and segments
DESCRIPTION: Head-to-head comparisons, benchmarking,
             and competitive analysis
============================================
*/

USE amazonSales;

/*
============================================
SECTION 1: PRODUCT VS PORTFOLIO BENCHMARKS
============================================
Purpose: How do individual products compare to averages?
*/

-- 1.1: Products exceeding all portfolio averages
SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    (SELECT ROUND(AVG(rating), 2) FROM products) as portfolio_avg_rating,
    rating_count,
    (SELECT ROUND(AVG(rating_count), 0) FROM products) as portfolio_avg_reviews,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    (SELECT ROUND(AVG(discounted_price), 2) FROM products) as portfolio_avg_price
FROM products
WHERE rating > (SELECT AVG(rating) FROM products)
  AND rating_count > (SELECT AVG(rating_count) FROM products)
  AND discounted_price < (SELECT AVG(discounted_price) FROM products)
ORDER BY rating DESC
LIMIT 20;

-- 1.2: Products underperforming on all metrics
SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    (SELECT ROUND(AVG(rating), 2) FROM products) as portfolio_avg_rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
WHERE rating < (SELECT AVG(rating) FROM products)
  AND rating_count < (SELECT AVG(rating_count) FROM products)
ORDER BY rating ASC, rating_count ASC
LIMIT 20;

-- 1.3: Performance gap analysis
SELECT 
    product_name,
    rating,
    ROUND((SELECT AVG(rating) FROM products), 2) as avg_rating,
    ROUND(rating - (SELECT AVG(rating) FROM products), 2) as rating_gap,
    rating_count,
    ROUND((SELECT AVG(rating_count) FROM products), 0) as avg_reviews,
    ROUND(rating_count - (SELECT AVG(rating_count) FROM products), 0) as review_gap
FROM products
WHERE ABS(rating - (SELECT AVG(rating) FROM products)) > 1.0
ORDER BY ABS(rating - (SELECT AVG(rating) FROM products)) DESC
LIMIT 30;

/*
============================================
SECTION 2: CATEGORY HEAD-TO-HEAD COMPARISON
============================================
Purpose: Compare categories against each other
*/

-- 2.1: Top 10 categories vs Bottom 10 categories
(
    SELECT 
        'TOP 10' as group_type,
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        COUNT(*) as products,
        ROUND(AVG(rating), 2) as avg_rating,
        ROUND(AVG(discounted_price), 2) as avg_price,
        SUM(rating_count) as total_reviews
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
    ORDER BY AVG(rating) DESC
    LIMIT 10
)
UNION ALL
(
    SELECT 
        'BOTTOM 10' as group_type,
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        COUNT(*) as products,
        ROUND(AVG(rating), 2) as avg_rating,
        ROUND(AVG(discounted_price), 2) as avg_price,
        SUM(rating_count) as total_reviews
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
    ORDER BY AVG(rating) ASC
    LIMIT 10
);

-- 2.2: Category performance matrix (Rating vs Engagement)
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_reviews,
    CASE 
        WHEN AVG(rating) >= 4.3 THEN 'High Rating'
        WHEN AVG(rating) >= 4.0 THEN 'Good Rating'
        ELSE 'Average Rating'
    END as rating_segment,
    CASE 
        WHEN SUM(rating_count) >= 50000 THEN 'High Engagement'
        WHEN SUM(rating_count) >= 10000 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END as engagement_segment
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 5
ORDER BY avg_rating DESC, total_reviews DESC;

-- 2.3: Category overlap analysis (similar performance)
WITH category_metrics AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(rating) as avg_rating,
        AVG(discounted_price) as avg_price,
        COUNT(*) as product_count
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
    HAVING product_count >= 5
)
SELECT 
    c1.main_category as category_1,
    c2.main_category as category_2,
    ROUND(c1.avg_rating, 2) as cat1_rating,
    ROUND(c2.avg_rating, 2) as cat2_rating,
    ROUND(ABS(c1.avg_rating - c2.avg_rating), 2) as rating_difference,
    ROUND(c1.avg_price, 2) as cat1_price,
    ROUND(c2.avg_price, 2) as cat2_price
FROM category_metrics c1
JOIN category_metrics c2 ON c1.main_category < c2.main_category
WHERE ABS(c1.avg_rating - c2.avg_rating) < 0.2
  AND ABS(c1.avg_price - c2.avg_price) < 1000
ORDER BY rating_difference ASC
LIMIT 20;

/*
============================================
SECTION 3: PRICE SEGMENT COMPARISON
============================================
Purpose: Compare performance across price tiers
*/

-- 3.1: Performance by price tier
SELECT 
    CASE 
        WHEN discounted_price < 500 THEN 'Budget (<₹500)'
        WHEN discounted_price < 1500 THEN 'Economy (₹500-1500)'
        WHEN discounted_price < 5000 THEN 'Mid-Range (₹1500-5000)'
        WHEN discounted_price < 15000 THEN 'Premium (₹5000-15000)'
        ELSE 'Luxury (₹15000+)'
    END as price_tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(MIN(discounted_price), 2) as min_price,
    ROUND(MAX(discounted_price), 2) as max_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount
FROM products
GROUP BY price_tier
ORDER BY AVG(discounted_price);

-- 3.2: Best performing tier vs Worst performing tier
(
    SELECT 
        'BEST TIER' as performance,
        CASE 
            WHEN discounted_price < 500 THEN 'Budget'
            WHEN discounted_price < 1500 THEN 'Economy'
            WHEN discounted_price < 5000 THEN 'Mid-Range'
            WHEN discounted_price < 15000 THEN 'Premium'
            ELSE 'Luxury'
        END as price_tier,
        COUNT(*) as products,
        ROUND(AVG(rating), 2) as avg_rating
    FROM products
    GROUP BY price_tier
    ORDER BY AVG(rating) DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 
        'WORST TIER' as performance,
        CASE 
            WHEN discounted_price < 500 THEN 'Budget'
            WHEN discounted_price < 1500 THEN 'Economy'
            WHEN discounted_price < 5000 THEN 'Mid-Range'
            WHEN discounted_price < 15000 THEN 'Premium'
            ELSE 'Luxury'
        END as price_tier,
        COUNT(*) as products,
        ROUND(AVG(rating), 2) as avg_rating
    FROM products
    GROUP BY price_tier
    ORDER BY AVG(rating) ASC
    LIMIT 1
);

/*
============================================
SECTION 4: DISCOUNT STRATEGY COMPARISON
============================================
Purpose: Compare discounted vs non-discounted products
*/

-- 4.1: Heavy discount vs Light discount performance
SELECT 
    CASE 
        WHEN discount_percentage >= 50 THEN 'Heavy Discount (50%+)'
        WHEN discount_percentage >= 25 THEN 'Moderate Discount (25-49%)'
        WHEN discount_percentage > 0 THEN 'Light Discount (1-24%)'
        ELSE 'No Discount'
    END as discount_tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_final_price
FROM products
GROUP BY discount_tier
ORDER BY AVG(discount_percentage);

-- 4.2: Top categories: discounted vs non-discounted
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(CASE WHEN discount_percentage > 0 THEN 1 END) as discounted_products,
    ROUND(AVG(CASE WHEN discount_percentage > 0 THEN rating END), 2) as discounted_avg_rating,
    COUNT(CASE WHEN discount_percentage = 0 THEN 1 END) as non_discounted_products,
    ROUND(AVG(CASE WHEN discount_percentage = 0 THEN rating END), 2) as non_discounted_avg_rating,
    ROUND(
        AVG(CASE WHEN discount_percentage > 0 THEN rating END) - 
        AVG(CASE WHEN discount_percentage = 0 THEN rating END), 
        2
    ) as rating_difference
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING discounted_products >= 3 AND non_discounted_products >= 3
ORDER BY ABS(rating_difference) DESC
LIMIT 20;

/*
============================================
SECTION 5: RATING TIER COMPARISON
============================================
Purpose: Compare high-rated vs low-rated product characteristics
*/
