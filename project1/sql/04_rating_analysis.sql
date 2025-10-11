use amazonSales;

/*
============================================
SECTION 0: RATING OVERVIEW
============================================
Purpose: Basic rating statistics
*/

-- 0.1: Overall rating statistics 

SELECT  
    COUNT(*) as total_products,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(MIN(rating), 2) as min_rating,
    ROUND(MAX(rating), 2) as max_rating,
    COUNT(CASE WHEN rating >= 4.5 THEN 1 END) as highly_rated_count
FROM products 
WHERE rating IS NOT NULL;

/*
============================================
SECTION 1: RATING DISTRIBUTION
============================================
Purpose: Understand how ratings are distributed
*/

-- 1.1: Rating distribution 
SELECT 
    CASE
        WHEN rating >= 4.0 THEN '4.0 - 5.0 ★★★★★'
        WHEN rating >= 3.0 THEN '3.0 - 4.0 ★★★★'
        WHEN rating >= 2.0 THEN '2.0 - 3.0 ★★★'
        WHEN rating >= 1.0 THEN '1.0. - 2.0 ★★'
        ELSE 'Under 1.0 ★'
    END as rating_bracket,
    COUNT(*) as product_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 2) as percentage,
    ROUND(AVG(discounted_price), 2) as avg_price
FROM products
WHERE rating IS NOT NULL
GROUP BY rating_bracket
ORDER BY product_count DESC;

-- 1.2: Rating concentration analysis
SELECT 
    'Perfect 5.0' as rating_category,
    COUNT(*) as count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 2) as percentage
FROM products
WHERE rating = 5.0

UNION ALL 

SELECT 
    '4.5 - 4.9',
    COUNT(*), 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 2)
FROM products 
WHERE rating >= 4.5 AND rating <= 4.9

UNION ALL 

SELECT 
    '4.0 - 4.4',
    COUNT(*), 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 2)
FROM products 
WHERE rating >= 4.0 AND rating <= 4.4

UNION ALL 

SELECT 
    'Under 4.0',
    COUNT(*), 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 2)
FROM products 
WHERE rating < 4.0;

/*
============================================
SECTION 2: RATING RELIABILITY ANALYSIS
============================================
Purpose: Understand rating trustworthiness based on review volume
*/

-- 2.1: Rating reliability tiers

SELECT 
    CASE 
        WHEN rating_count >= 1000 THEN 'Highly Reliable (1000+ Reviews)'
        WHEN rating_count >= 500 THEN 'Very Reliable (500 - 999 Reviews)'
        WHEN rating_count >= 100 THEN 'Reliable (100 - 499 Reviews)'
        WHEN rating_count >= 50 THEN 'Moderately Reliable (50 - 99 Reviews)'
        WHEN rating_count >= 10 THEN 'Limited Reliability (10 - 49 Reviews)'
        ELSE 'Unreliable (< 10 Reviews)'
    END as reliability,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating
FROM products
GROUP BY reliability
ORDER BY product_count DESC;

-- 2.2: Rating consistency by review volume
SELECT 
    CASE 
        WHEN rating_count < 10 THEN '0-9 reviews'
        WHEN rating_count < 50 THEN '10-49 reviews'
        WHEN rating_count < 100 THEN '50-99 reviews'
        WHEN rating_count < 500 THEN '100-499 reviews'
        WHEN rating_count < 1000 THEN '500-999 reviews'
        ELSE '1000+ reviews'
    END as review_volume,
    COUNT(*) as products,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(MIN(rating), 2) as min_rating,
    ROUND(MAX(rating), 2) as max_rating,
    ROUND(STDDEV(rating), 2) as std_dev
FROM products
GROUP BY review_volume
ORDER BY MIN(rating_count);

-- 2.3: Products with suspicious ratings (perfect 5.0 with high volume)
SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
WHERE rating = 5.0 
  AND rating_count >= 100
ORDER BY rating_count DESC
LIMIT 20;

/*
============================================
SECTION 3: RATING VS REVIEW COUNT CORRELATION
============================================
Purpose: Does more reviews = different ratings?
*/

SELECT 
    CASE 
        WHEN rating_count = 0 THEN 'No reviews'
        WHEN rating_count < 10 THEN '1-9 reviews'
        WHEN rating_count < 50 THEN '10-49 reviews'
        WHEN rating_count < 100 THEN '50-99 reviews'
        WHEN rating_count < 500 THEN '100-499 reviews'
        WHEN rating_count < 1000 THEN '500-999 reviews'
        ELSE '1000+ reviews'
    END as review_bracket,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(MIN(rating), 2) as min_rating,
    ROUND(MAX(rating), 2) as max_rating
FROM products
GROUP BY review_bracket
ORDER BY MIN(rating_count);


-- 3.2: High ratings with low engagement (potential quality or visibility issue)
SELECT 
    product_name,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    discount_percentage
FROM products
WHERE rating >= 4.5 
  AND rating_count < 10
ORDER BY rating DESC, rating_count ASC
LIMIT 30;

-- 3.3: Low ratings with high engagement (consistent disappointment)
SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
WHERE rating < 3.0 
  AND rating_count >= 100
ORDER BY rating_count DESC
LIMIT 20;

/*
============================================
SECTION 4: RATING BY CATEGORY
============================================
Purpose: Which categories have better/worse ratings?
*/

-- 4.1: Average rating by main category
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(STDDEV(rating), 2) as rating_std_dev,
    ROUND(MIN(rating), 2) as min_rating,
    ROUND(MAX(rating), 2) as max_rating,
    SUM(rating_count) as total_reviews
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 5
ORDER BY avg_rating DESC;

-- 4.2: Categories with most consistent ratings (low std dev)
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(STDDEV(rating), 2) as rating_std_dev,
    CASE 
        WHEN STDDEV(rating) < 0.3 THEN 'Very Consistent'
        WHEN STDDEV(rating) < 0.5 THEN 'Consistent'
        WHEN STDDEV(rating) < 0.8 THEN 'Moderate'
        ELSE 'Inconsistent'
    END as consistency_level
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 10
ORDER BY rating_std_dev ASC
LIMIT 20;

-- 4.3: Categories with most inconsistent ratings (high std dev)
SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(STDDEV(rating), 2) as rating_std_dev,
    ROUND(MAX(rating) - MIN(rating), 2) as rating_range
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 10
ORDER BY rating_std_dev DESC
LIMIT 20;

/*
============================================
SECTION 5: RATING GAPS & OUTLIERS
============================================
Purpose: Find unusual rating patterns
*/

-- 5.1: Products with rating significantly above category average
WITH category_avg AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(rating) as avg_category_rating
    FROM products
    GROUP BY main_category
)
SELECT 
    p.product_name,
    SUBSTRING_INDEX(p.category, '|', 1) as main_category,
    p.rating as product_rating,
    ROUND(ca.avg_category_rating, 2) as category_avg,
    ROUND(p.rating - ca.avg_category_rating, 2) as rating_difference,
    p.rating_count
FROM products p
JOIN category_avg ca ON SUBSTRING_INDEX(p.category, '|', 1) = ca.main_category
WHERE p.rating - ca.avg_category_rating >= 1.0
  AND p.rating_count >= 20
ORDER BY rating_difference DESC
LIMIT 30;

-- 5.2: Products with rating significantly below category average
WITH category_avg AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(rating) as avg_category_rating
    FROM products
    GROUP BY main_category
)
SELECT 
    p.product_name,
    SUBSTRING_INDEX(p.category, '|', 1) as main_category,
    p.rating as product_rating,
    ROUND(ca.avg_category_rating, 2) as category_avg,
    ROUND(ca.avg_category_rating - p.rating, 2) as rating_gap,
    p.rating_count
FROM products p
JOIN category_avg ca ON SUBSTRING_INDEX(p.category, '|', 1) = ca.main_category
WHERE ca.avg_category_rating - p.rating >= 1.0
  AND p.rating_count >= 20
ORDER BY rating_gap DESC
LIMIT 30;

/*
============================================
SECTION 6: RATING DENSITY ANALYSIS
============================================
Purpose: Review engagement intensity
*/

-- 6.1: Review density by rating level
SELECT 
    CASE 
        WHEN rating >= 4.5 THEN 'Excellent (4.5+)'
        WHEN rating >= 4.0 THEN 'Very Good (4.0-4.4)'
        WHEN rating >= 3.5 THEN 'Good (3.5-3.9)'
        WHEN rating >= 3.0 THEN 'Average (3.0-3.4)'
        ELSE 'Below Average (<3.0)'
    END as rating_tier,
    COUNT(*) as product_count,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    SUM(rating_count) as total_reviews,
    ROUND(SUM(rating_count) * 100.0 / (SELECT SUM(rating_count) FROM products), 2) as pct_of_total_reviews
FROM products
WHERE rating IS NOT NULL
GROUP BY rating_tier
ORDER BY MIN(rating) DESC;

-- 6.2: Products with disproportionate review volume
SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as category,
    rating,
    rating_count,
    (SELECT AVG(rating_count) FROM products) as portfolio_avg_reviews,
    ROUND(rating_count / (SELECT AVG(rating_count) FROM products), 2) as review_multiplier
FROM products
WHERE rating_count > (SELECT AVG(rating_count) FROM products) * 5
ORDER BY rating_count DESC
LIMIT 20;

/*
============================================
SECTION 7: RATING QUALITY INDICATORS
============================================
Purpose: Signals of authentic vs questionable ratings
*/

-- 7.1: Potential review quality concerns (perfect ratings with moderate volume)
SELECT 
    product_name,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    discount_percentage,
    CASE 
        WHEN rating = 5.0 AND rating_count BETWEEN 50 AND 200 THEN 'Monitor - Perfect rating'
        WHEN rating >= 4.9 AND rating_count < 20 THEN 'Low volume - Verify'
        ELSE 'Normal'
    END as quality_flag
FROM products
WHERE (rating = 5.0 AND rating_count BETWEEN 50 AND 200)
   OR (rating >= 4.9 AND rating_count < 20)
ORDER BY rating DESC, rating_count DESC
LIMIT 30;

-- 7.2: Rating vs price correlation check
SELECT 
    CASE 
        WHEN discounted_price < 500 THEN 'Budget (<$500)'
        WHEN discounted_price < 1500 THEN 'Economy ($500-1500)'
        WHEN discounted_price < 5000 THEN 'Mid-Range ($1500-5000)'
        WHEN discounted_price < 15000 THEN 'Premium ($5000-15000)'
        ELSE 'Luxury ($15000+)'
    END as price_segment,
    COUNT(*) as products,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(STDDEV(rating), 2) as rating_variation
FROM products
WHERE rating IS NOT NULL
GROUP BY price_segment
ORDER BY AVG(discounted_price);

/*
============================================
SECTION 8: SUMMARY INSIGHTS
============================================
Purpose: Key rating insights for stakeholders
*/

-- 8.1: Rating health dashboard
SELECT 
    'Portfolio Avg Rating' as metric,
    CAST(ROUND(AVG(rating), 2) AS CHAR) as value
FROM products
WHERE rating IS NOT NULL
UNION ALL
SELECT 
    'Highly Rated Products (4.0+)',
    CONCAT(
        COUNT(CASE WHEN rating >= 4.0 THEN 1 END),
        ' (',
        ROUND(COUNT(CASE WHEN rating >= 4.0 THEN 1 END) * 100.0 / COUNT(*), 1),
        '%)'
    )
FROM products
WHERE rating IS NOT NULL
UNION ALL
SELECT 
    'Products Needing Attention (<3.5)',
    CONCAT(
        COUNT(CASE WHEN rating < 3.5 THEN 1 END),
        ' (',
        ROUND(COUNT(CASE WHEN rating < 3.5 THEN 1 END) * 100.0 / COUNT(*), 1),
        '%)'
    )
FROM products
WHERE rating IS NOT NULL
UNION ALL
SELECT 
    'Avg Reviews per Product',
    CAST(ROUND(AVG(rating_count), 0) AS CHAR)
FROM products
UNION ALL
SELECT 
    'Total Customer Reviews',
    FORMAT(SUM(rating_count), 0)
FROM products;

-- 8.2: Rating distribution summary
SELECT 
    '5-Star Products' as category,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 1) as percentage
FROM products
WHERE FLOOR(rating) = 5
UNION ALL
SELECT '4-Star Products', COUNT(*), ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 1)
FROM products WHERE FLOOR(rating) = 4
UNION ALL
SELECT '3-Star Products', COUNT(*), ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 1)
FROM products WHERE FLOOR(rating) = 3
UNION ALL
SELECT '2-Star Products', COUNT(*), ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 1)
FROM products WHERE FLOOR(rating) = 2
UNION ALL
SELECT '1-Star Products', COUNT(*), ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 1)
FROM products WHERE FLOOR(rating) = 1;


