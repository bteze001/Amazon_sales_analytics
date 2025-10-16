
/*
============================================
PRODUCT PERFORMANCE ANALYSIS
============================================
*/ 
use amazonSales;

/* 
============================================
 SECTION 0: Total Summary Overview 
============================================
*/

-- 0.0: Total Products 
SELECT COUNT(*) as total_products
FROM products;

-- 0.1: Unique categories 
SELECT COUNT(DISTINCT category) as total_categories
FROM products;

-- 0.2: Average price/discount 
SELECT 
    ROUND(AVG(discounted_price), 2) as avg_discounted_price,
    ROUND(AVG(actual_price), 2) as avg_actual_price,
    ROUND(AVG(discount_percentage), 2) as avg_discount_percentage
FROM products;

-- 0.3: Average rating
SELECT 
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 2) as avg_rating_count
FROM products;

/* 
============================================
 SECTION 1: TOP PERFORMING PRODUCTS
============================================
Purpose: Identify products that excel in ratings and engagement
*/

-- 1.1: Top 10 highest rated products with significant reviews

/*
Purpose: Find genuinely excellent products with enough reviews to be trusted
Business Value: Products to feature in marketing campaigns
*/

SELECT 
    product_id,
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    ROUND(discount_percentage, 1) as discount_percentage
FROM products
WHERE rating_count >= 50
ORDER BY rating DESC, rating_count DESC
LIMIT 10;

-- 1.2: Products with perfect or near-perfect ratings

/*
Purpose: Identify products with exceptional customer satisfaction
Business Value: Understand what makes products highly rated
*/

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    ROUND(discount_percentage, 1) as discount_percentage
FROM products
WHERE rating >= 4.8 AND rating_count >= 100
ORDER BY rating_count DESC
LIMIT 10;

-- 1.3: Top 10 most-reviewed products

/*
Purpose: Identify most engaging products
Business Value: High engagement products = high visibility
*/

SELECT 
    product_name, 
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    rating, 
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
ORDER BY rating_count DESC
LIMIT 10;

/*
============================================
SECTION 2: HIDDEN GEMS
============================================
Purpose: Find underrated high-quality products
*/

-- 2.1: Products with High rating but low review count

/*
Purpose: Find high-quality products that haven't gained traction yet
Business Value: Marketing opportunity - promote these products
Portfolio Insight: For resume bullet point about identifying $200K opportunity
*/

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    rating, 
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
WHERE rating >= 4.8 AND rating_count BETWEEN 10 AND 150
ORDER BY rating DESC, rating_count ASC 
LIMIT 10; 

-- 2.2: Calculate potential revenue from hidden gems
/*
Purpose: Quantify the business opportunity
Business Value: If these products get more reviews, estimated revenue impact

Revenue = Units Sold X Price per unit but we dont have units sold in this data 
            So we will use the rating_count as a proxy for "units sold" 

We are asking the question what if these products sole 50 more units
Which caluclates the potential revenue growth of this product 
*/

SELECT 
    'Hidden Gems Analysis' as metirc,
    COUNT(*) as product_count, 
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(SUM(discounted_price * 50), 2) as revenue,
    ROUND(
        ((SUM(discounted_price * (rating_count + 50)) - SUM(discounted_price * rating_count)) 
         / SUM(discounted_price * rating_count)) * 100, 2
    ) AS revenue_increase_percent
FROM products
WHERE rating >= 4.8 AND rating_count BETWEEN 10 AND 100;

-- 2.3: Hidden Gem by Category 
/*
Purpose: Which categories have the most untapped potential?
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) product_count,
    AVG(rating) as avg_rating,
    AVG(rating_count) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price
FROM products
WHERE rating >= 4.8 AND rating_count BETWEEN 10 AND 100
GROUP BY main_category
ORDER BY product_count DESC; 

/*
============================================
SECTION 3: UNDERPERFORMING PRODUCTS
============================================
Purpose: Identify products that need improvement or removal
*/
-- 3.1: Products with poor ratings but high review volume
/*
Purpose: Products that consistently disappoint customers
Business Value: Consider removing from catalog or improving quality
*/

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    discount_percentage
FROM products
WHERE rating < 3.0 AND rating_count > 100
ORDER BY rating_count DESC, rating ASC
LIMIT 10;

-- 3.2: Low-rated products by category 
/* Purpose: Which categories have quality issues? */

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    AVG(rating) AS avg_rating,
    AVG(rating_count) as avg_reviews
FROM products
WHERE rating < 3.0
GROUP BY main_category
ORDER BY product_count DESC;

-- 3.3: Products with declining perceived value (high discount, low rating)
/*
Purpose: Heavy discounts + low ratings = quality concerns
Business Value: These products damage brand reputation
*/

SELECT 
    product_name,
    rating,
    rating_count,
    discount_percentage,
    CONCAT('$', ROUND(actual_price, 2)) as original_price,
    CONCAT('$', ROUND(discounted_price, 2)) as discounted_price
FROM products
WHERE discount_percentage > 50 AND rating <= 3.0
ORDER BY discount_percentage DESC
LIMIT 10;

/*
============================================
SECTION 4: WEIGHTED RATING ANALYSIS
============================================
Purpose: Account for both rating quality AND review volume
*/

-- 4.1: Bayesian average rating (weighted by review count)
/*
Purpose: More reliable ranking that balances rating quality with volume
Explanation: Products with few reviews are pulled toward average rating
Business Value: Better product recommendations than raw ratings alone
*/ 

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    rating as raw_rating,
    rating_count as reviews,
    ROUND(
        (rating_count / (rating_count + 50)) * rating + 
        (50 / (rating_count + 50)) * (SELECT AVG(rating) FROM products),
        2
    ) as weighted_rating,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
WHERE rating_count > 5  -- At least some reviews
ORDER BY weighted_rating DESC
LIMIT 10;



-- 4.2: Compare raw vs weighted ratings for top products 
/*
Purpose: See which products are most affected by weighting
Insight: Products with few reviews get adjusted more
*/

SELECT 
    product_name,
    rating as raw_rating,
    rating_count,
    ROUND(
        (rating_count / (rating_count + 50)) * rating + 
        (50 / (rating_count + 50)) * (SELECT AVG(rating) FROM products),
        2
    ) as weighted_rating,
    ROUND(
        rating - (
            (rating_count / (rating_count + 50)) * rating + 
            (50 / (rating_count + 50)) * (SELECT AVG(rating) FROM products)
        ),
        2
    ) as rating_adjustment
FROM products
WHERE rating >= 4.5
ORDER BY ABS(rating_adjustment) DESC
LIMIT 10;

/*
============================================
SECTION 5: PRICE-PERFORMANCE ANALYSIS
============================================
Purpose: Understand relationship between price and ratings
*/

-- 5.1: Best value products (high rating, low price)
/*
Purpose: Best bang for your buck - high quality, low price
Business Value: Great for budget-conscious customers
*/ 

SELECT 
    product_name,
    rating,
    rating_count,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    ROUND(rating/discounted_price, 2) as value_score
FROM products 
WHERE rating >= 4.0 AND
    rating_count >= 50 AND
    discounted_price > 0
ORDER BY value_score DESC
LIMIT 10;



-- 5.2: Premium products (high price, high rating)
/*
Purpose: Identify premium products that justify their price
Business Value: High-margin products with quality backing
*/

SELECT 
    product_name, 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    discount_percentage
FROM products
WHERE discounted_price > 100 AND rating >= 4.5 AND rating_count >= 50 
ORDER BY discounted_price DESC
LIMIT 10;

-- 5.3: Rating by price tier 
/*
Purpose: Does price correlate with quality?
Insight: See if customers are more critical of expensive products
*/

SELECT 
    CASE 
        WHEN discounted_price < 500 THEN 'LOW'
        WHEN discounted_price BETWEEN 500 AND 1500 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS price_tier,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND (AVG(rating), 2) as avg_rating,
    COUNT(*) as product_count
FROM products
WHERE rating IS NOT NULL
GROUP BY price_tier
ORDER BY avg_price;


/*
=============================================
SECTION 6: ENGAGEMENT ANALYSIS
=============================================
Purpose: Understand review engagement patterns
*/

-- 6.1: Products with best engagement (high review count relative to category)
/*
Purpose: Products that generate way more engagement than expected
Business Value: What makes these products so engaging?
*/

WITH category_avg AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(rating_count) as avg_reviews
    FROM products
    GROUP BY main_category
)
SELECT 
    p.product_name,
    SUBSTRING_INDEX(p.category, '|', 1) as main_category,
    p.rating,
    p.rating_count,
    ROUND(ca.avg_reviews, 0) as category_avg_reviews,
    ROUND(
        (p.rating_count - ca.avg_reviews) / ca.avg_reviews * 100, 
        1
    ) as pct_above_category_avg
FROM products p
JOIN category_avg ca ON SUBSTRING_INDEX(p.category, '|', 1) = ca.main_category
WHERE p.rating_count > ca.avg_reviews
ORDER BY pct_above_category_avg DESC
LIMIT 30;

-- 6.2: Low engagement products (below category average)
/*
Purpose: Products not getting attention they deserve
Business Value: Marketing/visibility opportunity
*/

WITH category_avg AS (
    SELECT 
        SUBSTRING_INDEX(category, '|', 1) as main_category,
        AVG(rating_count) as avg_reviews
    FROM products
    GROUP BY main_category
)
SELECT 
    p.product_name,
    SUBSTRING_INDEX(p.category, '|', 1) as main_category,
    p.rating,
    p.rating_count,
    ROUND(ca.avg_reviews, 0) as category_avg_reviews,
    ROUND(
        (ca.avg_reviews - p.rating_count) / ca.avg_reviews * 100, 
        1
    ) as pct_below_category_avg
FROM products p
JOIN category_avg ca ON SUBSTRING_INDEX(p.category, '|', 1) = ca.main_category
WHERE p.rating_count < ca.avg_reviews * 0.5  -- Less than 50% of average
ORDER BY pct_below_category_avg DESC
LIMIT 30;

/*
============================================
SECTION 7: PRODUCT BENCHMARKING
============================================
Purpose: Compare products against portfolio averages
*/

-- 7.1: Products performing above portfolio average 
/*
Purpose: Identify above-average performers
Business Value: Learn from success patterns
*/

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    rating,
    rating_count,
    (SELECT AVG(rating) FROM products) as avg_rating,
    ROUND(rating - (SELECT AVG(rating) FROM products), 2) as rating_vs_avg,
    CONCAT('$', ROUND(discounted_price, 2)) as price,
    discount_percentage
FROM products
WHERE rating > (SELECT AVG(rating) FROM products)
    AND rating_count >= 50
ORDER BY rating_vs_avg DESC
LIMIT 10;

-- 7.2: Products performing below portfolio average
/*
Purpose: Identify below-average performers
Business Value: Candidates for removal or improvement
*/

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as category,
    rating,
    (SELECT AVG(rating) FROM products) as portfolio_avg_rating,
    ROUND(rating - (SELECT AVG(rating) FROM products), 2) as rating_vs_avg,
    rating_count,
    discount_percentage
FROM products
WHERE rating < (SELECT AVG(rating) FROM products)
  AND rating_count >= 50
ORDER BY rating_vs_avg ASC
LIMIT 10;

/*
============================================
SECTION 8: PERCENTILE ANALYSIS
============================================
Purpose: Understand distribution and identify outliers
*/

-- 8.1: Top 10% of products by rating (minimum review threshold)
/*
Purpose: Elite products - top 10% by rating
Business Value: Premium product showcase
*/

SELECT 
    product_name,
    SUBSTRING_INDEX(category, '|', -1) as category,
    rating,
    rating_count,
    CONCAT('$', ROUND(discounted_price, 2)) as price
FROM products
WHERE rating_count >= 20
ORDER BY rating DESC
LIMIT 10;

-- 8.2: Bottom 10% of products by rating
/*
Purpose: Worst performers - bottom 10%
Business Value: Immediate action needed
*/


/*
============================================
SECTION 9: SUMMARY INSIGHTS
============================================
Purpose: Key takeaways for stakeholders
*/

-- 9.1: Performance summary by rating bracket
/*
Purpose: Executive summary of product portfolio health
Business Value: One-query overview for leadership
*/

SELECT 
    CASE 
        WHEN rating >= 4.5 THEN 'Excellent (4.5-5.0)'
        WHEN rating >= 4.0 THEN 'Very Good (4.0-4.4)'
        WHEN rating >= 3.5 THEN 'Good (3.5-3.9)'
        WHEN rating >= 3.0 THEN 'Average (3.0-3.4)'
        ELSE 'Below Average (<3.0)'
    END as performance_category,
    COUNT(*) as product_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE rating IS NOT NULL), 2) as percentage,
    ROUND(AVG(rating_count), 0) as avg_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(SUM(discounted_price * rating_count), 2) as estimated_revenue
FROM products
WHERE rating IS NOT NULL
GROUP BY performance_category
ORDER BY MIN(rating) DESC;

-- 9.2: Key product metrics dashboard 

(SELECT 
    'Top Rated Product' as metric,
    product_name as value
FROM products
WHERE rating_count >= 50
ORDER BY rating DESC
LIMIT 1
)

UNION ALL

(SELECT 
    'Most Reviewed Product',
    product_name
FROM products
ORDER BY rating_count DESC
LIMIT 1
)

UNION ALL

(SELECT 
    'Most Expensive Product',
    CONCAT(product_name, ' - $', ROUND(discounted_price, 2))
FROM products
ORDER BY discounted_price DESC
LIMIT 1
)

UNION ALL

(SELECT 
    'Best Value Product',
    product_name
FROM products
WHERE rating >= 4.5 AND rating_count >= 30
ORDER BY discounted_price ASC
LIMIT 1
);