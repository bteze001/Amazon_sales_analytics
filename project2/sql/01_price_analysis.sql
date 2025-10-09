
-- ============================================
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

