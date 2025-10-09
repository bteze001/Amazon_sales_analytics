-- ============================================
-- SECTION 1: DATABASE CREATION
-- ============================================

CREATE DATABASE IF NOT EXISTS amazonSales;
use amazonSales;

-- ============================================
-- SECTION 2: DROP TABLES IF ALREADY CREATED (Clean Slate)
-- ============================================
-- Note: Drop in reverse order of dependencies (reviews -> products/users)

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- ============================================
-- SECTION 3: TABLE CREATION
-- ============================================

-- Products tables: Core product information

CREATE TABLE IF NOT EXISTS products(
	product_id VARCHAR(255) PRIMARY KEY,
    product_name TEXT,
    category VARCHAR(255),
    about_product TEXT, 
    product_link TEXT,
    img_link TEXT,
    discounted_price DECIMAL(10,2),
    actual_price DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
	rating DECIMAL(2,1),
    rating_count DECIMAL(10,2),

    -- Indexes for query performance
    INDEX idx_category(category),
    INDEX idx_rating(rating),
    INDEX idx_price (discounted_price)
);

-- Users table: Customer information

CREATE TABLE IF NOT EXISTS users(
	user_id VARCHAR(500) PRIMARY KEY,
    user_name VARCHAR(500),

    INDEX idx_user_name (user_name)
);

-- Reviews table: Customer reviews

CREATE TABLE IF NOT EXISTS reviews(
	review_id VARCHAR(255) PRIMARY KEY,
    product_id VARCHAR(255),
    user_id VARCHAR(500),
    review_title VARCHAR(500),
    review_content TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,

    INDEX idx_user_review (user_id),
    INDEX idx_product_review (product_id)
);

-- ============================================
-- SECTION 4: DATA LOADING INSTRUCTIONS
-- ============================================

/* DATA LOADING STEPS

1. Install the latest version of MySQL and MySQL Workbench
2. Run the above query to create database and tables
3. Right-click on 'products' table
4. Select "Table Data Import Wizard"
5. Choose your CSV file
6. Map columns accordingly
7. Repeat for 'users' and 'reviews' tables

*/

/* Method 2: Loading file using python */

LOAD DATA LOCAL INFILE '/Users/bezatezera/Desktop/Data/amazonSales/data/processed/cleaned_products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, category, discounted_price, actual_price, discount_percentage, about_product, img_link, product_link, rating, rating_count);

LOAD DATA LOCAL INFILE '/Users/bezatezera/Desktop/Data/amazonSales/data/processed/cleaned_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, user_name);

LOAD DATA LOCAL INFILE '/Users/bezatezera/Desktop/Data/amazonSales/data/processed/cleaned_reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, user_id, product_id, review_title, review_content);

-- -- ============================================
-- -- SECTION 5: BASIC DATA VALIDATION
-- -- ============================================

-- Verify tables were created successfully
SHOW TABLES;

-- Check table structures
-- DESCRIBE products;
-- DESCRIBE users;
-- DESCRIBE reviews;

-- Verify data loaded (run after importing CSVs)

SELECT 
    'products' AS table_name,
    COUNT(*) AS row_count
FROM products 
UNION ALL 

SELECT 
    'users' AS table_name,
    COUNT(*) AS row_count
FROM users
UNION ALL

SELECT 
    'reviews' AS table_name,
    COUNT(*) AS row_count
FROM reviews;

-- -- Check for NULL primary keys
SELECT 
    'Products with NULL ID' AS check_name,
    COUNT(*) AS null_count
FROM products
WHERE product_id IS NULL;

SELECT 
    'Users with NULL ID' AS check_name,
    COUNT(*) AS null_count
FROM users
WHERE user_id IS NULL;

SELECT 
    'Reviews with NULL ID' AS check_name,
    COUNT(*) AS null_count
FROM reviews
WHERE review_id IS NULL;


-- Check for duplicate primary keys

SELECT 
    'Duplicate Product IDs' AS check_name,
    COUNT(*) AS duplicate_count
FROM (
    SELECT product_id 
    FROM products 
    GROUP BY product_id 
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT 
    'Duplicate User IDs' AS check_name,
    COUNT(*) as duplicate_count
   
FROM (
    SELECT user_id
    FROM users
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS duplicates; 

SELECT 
    'Duplicate Review IDs' AS check_name,
    COUNT(*) as duplicate_count
   
FROM (
    SELECT review_id
    FROM reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates; 


-- Verify foreign key relationships
SELECT 
    'Reviews without matching Product and User' As check_name,
    COUNT(*) AS orphaned_count
FROM reviews
WHERE product_id NOT IN (SELECT product_id FROM products) 
OR user_id NOT IN (SELECT user_id FROM users);

-- Check data integrity - prices

SELECT 
    'Products with Invalid Prices' AS check_name,
    COUNT(*) AS invalid_price_count
FROM products
WHERE discounted_price IS NULL
    OR actual_price IS NULL
    OR discounted_price <= 0
    OR actual_price <= 0;

-- Check data integrity - ratings
SELECT 
    'Products with Invalid Ratings' AS check_name,
    COUNT(*) AS invalid_rating_count
FROM products
WHERE rating IS NULL 
    OR rating < 0
    OR rating > 5;  

-- Check data integrity - discount logic
SELECT 
    'Products with invalid discount logic (discount > actual)' AS check_name,
    COUNT(*) AS invalid_discount
FROM products 
WHERE discounted_price > actual_price;

-- Check data integrity - negative rating counts 
SELECT 
    'Products with negative rating count' AS check_name,
    COUNT(*) AS neg_rating_count
FROM products
WHERE rating_count < 0;


-- ============================================
-- SECTION 6: VALIDATION SUMMARY
-- ============================================

SELECT 
    'Database Setup Complete' AS status,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(*) FROM reviews) AS total_reviews,
    (SELECT COUNT(DISTINCT category) FROM products) AS categories,
    ROUND((SELECT AVG(rating) FROM products), 2) AS avg_rating,
    ROUND((SELECT AVG(discounted_price) FROM products), 2) AS avg_price;