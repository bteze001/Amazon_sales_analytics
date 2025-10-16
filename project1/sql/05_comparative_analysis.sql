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
-- aggregated table
SELECT * FROM (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) AS main_category,
        COUNT(*) AS products,
        ROUND(AVG(rating), 2) AS avg_rating,
        ROUND(AVG(discounted_price), 2) AS avg_price,
        SUM(rating_count) AS total_reviews
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
) AS agg;

-- Use derived tables for top and bottom, exclude overlap
SELECT 'TOP 5' AS group_type, t.main_category, t.products, t.avg_rating, t.avg_price, t.total_reviews
FROM (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) AS main_category,
        COUNT(*) AS products,
        ROUND(AVG(rating), 2) AS avg_rating,
        ROUND(AVG(discounted_price), 2) AS avg_price,
        SUM(rating_count) AS total_reviews
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
    ORDER BY avg_rating DESC, SUM(rating_count) DESC
    LIMIT 5
) AS t

UNION ALL

SELECT 'BOTTOM 5' AS group_type, b.main_category, b.products, b.avg_rating, b.avg_price, b.total_reviews
FROM (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) AS main_category,
        COUNT(*) AS products,
        ROUND(AVG(rating), 2) AS avg_rating,
        ROUND(AVG(discounted_price), 2) AS avg_price,
        SUM(rating_count) AS total_reviews
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
    ORDER BY avg_rating ASC, SUM(rating_count) DESC
    LIMIT 5  -- select more to account for exclusions if many top categories would be nearby
) AS b
LEFT JOIN (
    SELECT SUBSTRING_INDEX(category, '|', 1) AS main_category
    FROM products
    WHERE category IS NOT NULL
    GROUP BY main_category
    ORDER BY AVG(rating) DESC, SUM(rating_count) DESC
    LIMIT 5
) AS ttop ON b.main_category = ttop.main_category
WHERE ttop.main_category IS NULL
LIMIT 5;



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
-- Simple: remove wrapping parentheses
SELECT * FROM (
    SELECT 
        'BEST TIER' AS performance,
        CASE 
            WHEN discounted_price < 500 THEN 'Budget'
            WHEN discounted_price < 1500 THEN 'Economy'
            WHEN discounted_price < 5000 THEN 'Mid-Range'
            WHEN discounted_price < 15000 THEN 'Premium'
            ELSE 'Luxury'
        END AS price_tier,
        COUNT(*) AS products,
        ROUND(AVG(rating), 2) AS avg_rating
    FROM products
    GROUP BY price_tier
    ORDER BY AVG(rating) DESC, COUNT(*) DESC
    LIMIT 1
) AS best

UNION ALL

SELECT * FROM (
    SELECT 
        'WORST TIER' AS performance,
        CASE 
            WHEN discounted_price < 500 THEN 'Budget'
            WHEN discounted_price < 1500 THEN 'Economy'
            WHEN discounted_price < 5000 THEN 'Mid-Range'
            WHEN discounted_price < 15000 THEN 'Premium'
            ELSE 'Luxury'
        END AS price_tier,
        COUNT(*) AS products,
        ROUND(AVG(rating), 2) AS avg_rating
    FROM products
    GROUP BY price_tier
    ORDER BY AVG(rating) ASC, COUNT(*) DESC
    LIMIT 1
) AS worst;

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

-- 5.1: Elite products vs Poor products
SELECT 
    'ELITE (4.5+ Rating)' as tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount
FROM products
WHERE rating >= 4.5

UNION ALL

SELECT 
    'GOOD (4.0-4.4 Rating)' as tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount
FROM products
WHERE rating >= 4.0 AND rating < 4.5

UNION ALL

SELECT 
    'AVERAGE (3.5-3.9 Rating)' as tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount
FROM products
WHERE rating >= 3.5 AND rating < 4.0

UNION ALL

SELECT 
    'POOR (<3.5 Rating)' as tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount
FROM products
WHERE rating < 3.5;

-- 5.2: Rating vs Review volume correlation
SELECT 
    CASE 
        WHEN rating >= 4.5 THEN 'Elite (4.5+)'
        WHEN rating >= 4.0 THEN 'Good (4.0-4.4)'
        WHEN rating >= 3.5 THEN 'Average (3.5-3.9)'
        ELSE 'Poor (<3.5)'
    END as rating_tier,
    CASE 
        WHEN rating_count >= 10000 THEN 'Very High Reviews'
        WHEN rating_count >= 1000 THEN 'High Reviews'
        WHEN rating_count >= 100 THEN 'Medium Reviews'
        ELSE 'Low Reviews'
    END as review_tier,
    COUNT(*) as product_count,
    ROUND(AVG(discounted_price), 2) as avg_price
FROM products
GROUP BY rating_tier, review_tier
ORDER BY 
    FIELD(rating_tier, 'Elite (4.5+)', 'Good (4.0-4.4)', 'Average (3.5-3.9)', 'Poor (<3.5)'),
    FIELD(review_tier, 'Very High Reviews', 'High Reviews', 'Medium Reviews', 'Low Reviews');

-- 5.3: Category leaders vs laggards by rating
WITH category_ratings AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        product_name,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY SUBSTRING_INDEX(category, '|', 1) ORDER BY rating DESC, rating_count DESC) as rank_best,
        RANK() OVER (PARTITION BY SUBSTRING_INDEX(category, '|', 1) ORDER BY rating ASC, rating_count ASC) as rank_worst
    FROM products
    WHERE category IS NOT NULL
)
SELECT 
    main_category,
    MAX(CASE WHEN rank_best = 1 THEN product_name END) as best_product,
    MAX(CASE WHEN rank_best = 1 THEN rating END) as best_rating,
    MAX(CASE WHEN rank_worst = 1 THEN product_name END) as worst_product,
    MAX(CASE WHEN rank_worst = 1 THEN rating END) as worst_rating,
    ROUND(MAX(CASE WHEN rank_best = 1 THEN rating END) - 
          MAX(CASE WHEN rank_worst = 1 THEN rating END), 2) as rating_spread
FROM category_ratings
WHERE rank_best = 1 OR rank_worst = 1
GROUP BY main_category
HAVING rating_spread > 0
ORDER BY rating_spread DESC
LIMIT 20;

/*
============================================
SECTION 6: REVIEW ENGAGEMENT COMPARISON
============================================
Purpose: Compare high-engagement vs low-engagement products
*/

-- 6.1: High engagement vs Low engagement characteristics
SELECT 
    CASE 
        WHEN rating_count >= 10000 THEN 'Very High Engagement'
        WHEN rating_count >= 1000 THEN 'High Engagement'
        WHEN rating_count >= 100 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END as engagement_level,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount,
    ROUND(MIN(rating_count), 0) as min_reviews,
    ROUND(MAX(rating_count), 0) as max_reviews
FROM products
GROUP BY engagement_level
ORDER BY MIN(rating_count) DESC;

-- 6.2: Most engaged categories
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(rating_count), 0) as avg_reviews_per_product,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(SUM(rating_count) / COUNT(*), 0) as engagement_index
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 5
ORDER BY total_reviews DESC
LIMIT 15;

-- 6.3: Viral products (high reviews but varied ratings)
SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    rating_count,
    CONCAT('₹', ROUND(discounted_price, 2)) as price,
    ROUND(discount_percentage, 1) as discount_pct,
    CASE 
        WHEN rating >= 4.5 THEN 'Positive Viral'
        WHEN rating >= 4.0 THEN 'Mixed Viral'
        ELSE 'Controversial Viral'
    END as viral_type
FROM products
WHERE rating_count >= 5000
ORDER BY rating_count DESC
LIMIT 30;

/*
============================================
SECTION 7: DISCOUNT EFFECTIVENESS COMPARISON
============================================
Purpose: Analyze discount impact on different segments
*/

-- 7.1: Discount effectiveness by price tier
SELECT 
    CASE 
        WHEN discounted_price < 500 THEN 'Budget'
        WHEN discounted_price < 1500 THEN 'Economy'
        WHEN discounted_price < 5000 THEN 'Mid-Range'
        WHEN discounted_price < 15000 THEN 'Premium'
        ELSE 'Luxury'
    END as price_tier,
    ROUND(AVG(CASE WHEN discount_percentage > 30 THEN rating END), 2) as high_discount_rating,
    ROUND(AVG(CASE WHEN discount_percentage <= 30 AND discount_percentage > 0 THEN rating END), 2) as low_discount_rating,
    ROUND(AVG(CASE WHEN discount_percentage = 0 THEN rating END), 2) as no_discount_rating,
    COUNT(CASE WHEN discount_percentage > 30 THEN 1 END) as high_discount_count,
    COUNT(CASE WHEN discount_percentage <= 30 AND discount_percentage > 0 THEN 1 END) as low_discount_count,
    COUNT(CASE WHEN discount_percentage = 0 THEN 1 END) as no_discount_count
FROM products
GROUP BY price_tier
ORDER BY AVG(discounted_price);

-- 7.2: Category discount strategy winners
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as total_products,
    ROUND(AVG(discount_percentage), 1) as avg_discount,
    ROUND(AVG(CASE WHEN discount_percentage > 0 THEN rating END), 2) as discounted_rating,
    ROUND(AVG(CASE WHEN discount_percentage = 0 THEN rating END), 2) as full_price_rating,
    ROUND(
        AVG(CASE WHEN discount_percentage > 0 THEN rating END) - 
        AVG(CASE WHEN discount_percentage = 0 THEN rating END),
        3
    ) as discount_advantage,
    CASE 
        WHEN AVG(CASE WHEN discount_percentage > 0 THEN rating END) > AVG(CASE WHEN discount_percentage = 0 THEN rating END) 
        THEN 'Discount Helps'
        ELSE 'Full Price Better'
    END as strategy
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING COUNT(CASE WHEN discount_percentage > 0 THEN 1 END) >= 3
   AND COUNT(CASE WHEN discount_percentage = 0 THEN 1 END) >= 3
ORDER BY ABS(discount_advantage) DESC
LIMIT 20;

/*
============================================
SECTION 8: COMPREHENSIVE COMPARISON SUMMARY
============================================
Purpose: Overall portfolio comparison dashboard
*/

-- 8.1: Performance quadrant analysis
SELECT 
    CASE 
        WHEN rating >= (SELECT AVG(rating) FROM products) 
         AND rating_count >= (SELECT AVG(rating_count) FROM products) 
        THEN 'Stars (High Rating, High Engagement)'
        
        WHEN rating >= (SELECT AVG(rating) FROM products) 
         AND rating_count < (SELECT AVG(rating_count) FROM products) 
        THEN 'Hidden Gems (High Rating, Low Engagement)'
        
        WHEN rating < (SELECT AVG(rating) FROM products) 
         AND rating_count >= (SELECT AVG(rating_count) FROM products) 
        THEN 'Controversial (Low Rating, High Engagement)'
        
        ELSE 'Underperformers (Low Rating, Low Engagement)'
    END as performance_quadrant,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products), 1), '%') as portfolio_share
FROM products
GROUP BY performance_quadrant
ORDER BY product_count DESC;

-- 8.2: Category performance leaderboard
SELECT 
    RANK() OVER (ORDER BY AVG(rating) DESC, SUM(rating_count) DESC) as overall_rank,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as products,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount,
    CASE 
        WHEN AVG(rating) >= 4.5 AND SUM(rating_count) >= 50000 THEN '⭐ Star Category'
        WHEN AVG(rating) >= 4.3 THEN '✓ Strong Category'
        WHEN AVG(rating) >= 4.0 THEN '→ Average Category'
        ELSE '⚠ Needs Improvement'
    END as category_status
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING products >= 5
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 30;

-- 8.3: Final comparison summary
SELECT 
    'PORTFOLIO OVERVIEW' as metric_type,
    COUNT(*) as total_count,
    ROUND(AVG(rating), 2) as average_rating,
    ROUND(AVG(rating_count), 0) as average_reviews,
    ROUND(AVG(discounted_price), 2) as average_price,
    ROUND(AVG(discount_percentage), 1) as average_discount
FROM products

UNION ALL

SELECT 
    'TOP PERFORMERS (4.5+)',
    COUNT(*),
    ROUND(AVG(rating), 2),
    ROUND(AVG(rating_count), 0),
    ROUND(AVG(discounted_price), 2),
    ROUND(AVG(discount_percentage), 1)
FROM products
WHERE rating >= 4.5

UNION ALL

SELECT 
    'BOTTOM PERFORMERS (<3.5)',
    COUNT(*),
    ROUND(AVG(rating), 2),
    ROUND(AVG(rating_count), 0),
    ROUND(AVG(discounted_price), 2),
    ROUND(AVG(discount_percentage), 1)
FROM products
WHERE rating < 3.5;