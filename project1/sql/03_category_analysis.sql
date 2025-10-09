use amazonSales;

/* 
============================================
SECTION 1: CATEGORY OVERVIEW
============================================
Purpose: Understand category structure and distribution
*/

-- 1.1: Total unique categories (main level)

SELECT 
    COUNT(DISTINCT SUBSTRING_INDEX(category, '|', 1)) as total_main_categories,
    COUNT(DISTINCT SUBSTRING_INDEX(category, '|', -1)) as total_specific_categories,
    COUNT(DISTINCT category) as total_unique_paths
FROM products
WHERE category IS NOT NULL;

-- 1.2: Category depth distribution

SELECT 
    LENGTH(category) - LENGTH(REPLACE(category, '|', '')) + 1 as category_depth,
    COUNT(*) as product_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE category IS NOT NULL), 2) as percentage
FROM products
WHERE category IS NOT NULL
GROUP BY category_depth
ORDER BY category_depth;


-- 1.3: Sample of category paths at each depth

SELECT 
    LENGTH(category) - LENGTH(REPLACE(category, '|', '')) + 1 as depth,
    category as example_path
FROM products
WHERE category IS NOT NULL
GROUP BY depth, category
ORDER BY depth, category
LIMIT 20;


/*
============================================
SECTION 2: MAIN CATEGORY ANALYSIS
============================================
Purpose: Analyze top-level categories
*/
    
-- 2.1: Comprehensive main category breakdowm 
/*
Purpose: Complete overview of main categories
Business Value: Identify dominant categories and their characteristics
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products WHERE category IS NOT NULL), 2) as pct_of_total,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_reviews_per_product,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount_pct,
    ROUND(SUM(discounted_price * rating_count), 2) as estimated_revenue
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY product_count DESC;

-- 2.2: Top 10 main categories by product count 
/*
Purpose: Most represented categories in catalog
Portfolio Insight: "Electronics has 350 products with 4.5 avg rating"
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_customer_reviews
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY product_count DESC
LIMIT 10;
    
-- 2.3: Top 10 main categories by average rating 
/*
Purpose: Best performing categories by customer satisfaction
Business Value: Categories to expand
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_reviews
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 10 
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 10;

-- 2.4: Top 10 main categories by total reviews (engagement)
/*
Purpose: Most engaging categories
Business Value: High engagement = high customer interest
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(SUM(rating_count) / COUNT(*), 0) as avg_reviews_per_product
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY total_reviews DESC
LIMIT 10;

-- 2.5: Top 10 main categories by estimated revenue
/*
Purpose: Revenue drivers
Portfolio Insight: "Premium tier generates 52% of revenue despite 18% of inventory"
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(SUM(discounted_price * rating_count), 2) as estimated_revenue,
    ROUND(AVG(discounted_price), 2) as avg_product_price,
    ROUND(AVG(rating), 2) as avg_rating
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY estimated_revenue DESC
LIMIT 10;

/*
============================================
SECTION 3: SPECIFIC CATEGORY ANALYSIS
============================================
Purpose: Analyze leaf-level (most specific) categories
*/

-- 3.1: Top 20 specific categories by product count 
/* Purpose: Most common specific product types */

SELECT 
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(discounted_price), 2) as avg_price
FROM products
WHERE category IS NOT NULL
GROUP BY specific_category, main_category
ORDER BY product_count DESC
LIMIT 20;

-- 3.2: Best performing specific categories 
/* Purpose: Highest quality specific product types */

SELECT 
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_reviews
FROM products
WHERE category IS NOT NULL
GROUP BY specific_category, main_category
HAVING product_count >= 5  -- At least 5 products
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 20;

-- 3.3: Specific categories with most engagement 
/* Purpose: Most engaging specific product types */

SELECT 
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    COUNT(*) as product_count,
    SUM(rating_count) as total_reviews,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(SUM(rating_count) / COUNT(*), 0) as avg_reviews_per_product
FROM products
WHERE category IS NOT NULL
GROUP BY specific_category
HAVING product_count >= 3
ORDER BY avg_reviews_per_product DESC
LIMIT 20;

/*
============================================
SECTION 4: CATEGORY PERFORMANCE COMPARISON
============================================
Purpose: Compare categories against each other
*/

-- 4.1: Category performance matrix (rating vs volume)
/*
Purpose: Categorize categories into performance segments
Business Value: Quadrant analysis (high/low rating × high/low engagement)
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(rating_count) as total_reviews,
    CASE 
        WHEN AVG(rating) >= 4.5 THEN 'High Rating'
        WHEN AVG(rating) >= 4.0 THEN 'Good Rating'
        ELSE 'Needs Improvement'
    END as rating_tier,
    CASE 
        WHEN SUM(rating_count) >= 10000 THEN 'High Engagement'
        WHEN SUM(rating_count) >= 5000 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END as engagement_tier
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY avg_rating DESC, total_reviews DESC;

-- 4.2: Above vs below average categories 
/* Purpose: Which categories outperform/underperform the overall average? */

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as category_avg_rating,
    (SELECT ROUND(AVG(rating), 2) FROM products) as portfolio_avg_rating,
    ROUND(AVG(rating) - (SELECT AVG(rating) FROM products), 2) as rating_vs_portfolio_avg,
    CASE 
        WHEN AVG(rating) > (SELECT AVG(rating) FROM products) THEN 'Above Average'
        ELSE 'Below Average'
    END as performance_vs_average
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY rating_vs_portfolio_avg DESC;

-- 4.3: Category consistency analysis (rating standard deviation)
/*
Purpose: Which categories have consistent quality across products?
Business Value: Consistent categories = reliable brand promise
*/

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(rating), 2) as avg_rating,
    ROUND(STDDEV(rating), 2) as rating_std_dev,
    ROUND(MIN(rating), 2) as min_rating,
    ROUND(MAX(rating), 2) as max_rating,
    CASE 
        WHEN STDDEV(rating) < 0.5 THEN 'Very Consistent'
        WHEN STDDEV(rating) < 1.0 THEN 'Consistent'
        ELSE 'Inconsistent'
    END as consistency_level
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
HAVING product_count >= 10
ORDER BY rating_std_dev ASC;

/*
============================================
SECTION 5: CATEGORY DIVERSITY ANALYSIS
============================================
Purpose: Understand category complexity and variety
*/

-- 5.1: Main categories with most subcategories 
/* Purpose: Which main categories have most variety? */

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(DISTINCT SUBSTRING_INDEX(category, '|', -1)) as unique_specific_categories,
    COUNT(*) as total_products,
    ROUND(AVG(rating), 2) as avg_rating
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY unique_specific_categories DESC
LIMIT 15;

-- 5.2: Specific categories appearing in multiple main categories 
/* Purpose: Find ambiguous category names (e.g., "Cables" in multiple categories) */

SELECT 
    SUBSTRING_INDEX(category, '|', -1) as specific_category,
    COUNT(DISTINCT SUBSTRING_INDEX(category, '|', 1)) as appears_in_main_categories,
    GROUP_CONCAT(DISTINCT SUBSTRING_INDEX(category, '|', 1) ORDER BY SUBSTRING_INDEX(category, '|', 1) SEPARATOR ' | ') as main_categories,
    COUNT(*) as total_products
FROM products
WHERE category IS NOT NULL
GROUP BY specific_category
HAVING appears_in_main_categories > 1
ORDER BY appears_in_main_categories DESC, total_products DESC
LIMIT 20;

/*
============================================
SECTION 6: CATEGORY PRICING ANALYSIS
============================================
Purpose: Understand pricing strategies by category
*/

-- 6.1: Category pricing tiers 

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    CONCAT('$', ROUND(MIN(discounted_price), 2)) as min_price,
    CONCAT('$', ROUND(AVG(discounted_price), 2)) as avg_price,
    CONCAT('$', ROUND(MAX(discounted_price), 2)) as max_price,
    ROUND(AVG(discount_percentage), 1) as avg_discount_pct
FROM products
WHERE category IS NOT NULL AND discounted_price > 0
GROUP BY main_category
ORDER BY AVG(discounted_price) DESC;

-- 6.2: Most and least expensive categories 

SELECT 
    SUBSTRING_INDEX(category, '|', 1) as main_category,
    COUNT(*) as product_count,
    ROUND(AVG(discounted_price), 2) as avg_price,
    ROUND(AVG(rating), 2) as avg_rating,
    CASE 
        WHEN AVG(discounted_price) >= 100 THEN 'Premium'
        WHEN AVG(discounted_price) >= 50 THEN 'Mid-Range'
        ELSE 'Budget'
    END as price_category
FROM products
WHERE category IS NOT NULL
GROUP BY main_category
ORDER BY avg_price DESC
LIMIT 20;
