import pandas as pd
import re
import mysql.connector
from mysql.connector import Error

def split_data_into_tables():

    print("Step 1: Splitting data into normalized tables...")

    df = pd.read_csv("/Users/bezatezera/Desktop/Data/amazonSales/Amazon_sales_analytics/data/raw/amazon.csv")

    products = df[['product_id', 'product_name', 'category', 'discounted_price', 'actual_price', 
               'discount_percentage', 'about_product', 'img_link', 'product_link', 'rating', 
               'rating_count']].drop_duplicates()

    users = df[['user_id', 'user_name']].drop_duplicates()

    reviews = df[['review_id', 'user_id', 'product_id', 'review_title', 'review_content']]

    products.to_csv('products.csv', index=False)
    users.to_csv('users.csv', index=False)
    reviews.to_csv('reviews.csv', index=False)

def clean_special_characters(filename):

    print("Step 2: Cleaning special characters from {filename}...")

    df = pd.read_csv(filename, encoding='utf-8')

    def clean_special_chars(text):
        if pd.isna(text) or not isinstance(text, str):
            return text
    
    # Replace common problematic characters
        replacements = {
            '\u2019': "'",  # Smart apostrophe (')
            '\u201d': '"',  # Right double quotation mark (")
            '\u201c': '"',  # Left double quotation mark (")
            '\u3010': '[',  # Left black lenticular bracket (【)
            '\u3011': ']',  # Right black lenticular bracket (】)
            '\u2013': '-',  # En dash (–)
            '\u2014': '-',  # Em dash (—)
            '\u1f381': '',  # Gift emoji (🎁) - remove completely
            '\u2605': '*',  # Star (★)
            '\u00b0': ' degrees',  # Degree symbol (°)
            '\u03a9': 'Omega',  # Omega symbol (Ω)
            '\u00b1': '+/-',  # Plus-minus sign (±)
            '\u00d7': 'x',  # Multiplication sign (×)
            '\u00a0': ' ',  # Non-breaking space
            '\u200e': '',  # Left-to-right mark - remove
            '\u2764': '',  # Heart emoji - remove
            '\u270c': '',  # Victory hand emoji - remove
            '\u274c': '',  # Cross mark emoji - remove
            '\u1f44d': '',  # Thumbs up emoji - remove
            '\u2717': '',  # Ballot X - remove
            '\u2713': '',  # Check mark - remove
            '\u2728': '',  # Sparkles emoji - remove
        }
    
        # Apply replacements
        for unicode_char, replacement in replacements.items():
            text = text.replace(unicode_char, replacement)
    
        # Remove any remaining high Unicode characters (emojis, etc.)
        text = re.sub(r'[^\x00-\x7F]+', '', text)
    
        # Clean up multiple spaces
        text = re.sub(r'\s+', ' ', text).strip()
    
        return text

    # Apply cleaning to all text columns
    for col in df.select_dtypes(include=['object']).columns:
        df[col] = df[col].apply(clean_special_chars)

    # Save cleaned CSV
    cleaned_filename = f'cleaned_{filename}'
    df.to_csv(cleaned_filename, index=False, encoding='utf-8')
    print(f"Cleaned CSV saved as: {cleaned_filename}")

    return cleaned_filename

def clean_numeric_columns(filename, rupes_to_usd=0.012):

    print("Step 3: Cleaning numeric columns in {filename}...")

    df = pd.read_csv(filename)

    def clean_price_rating_data(value, convert_to_usd = False):
        if pd.isna(value):
            return None

        clean_value = str(value).replace(',','').replace('₹', '').strip()

        try:
            numeric_value = float(clean_value)
            if convert_to_usd:
                numeric_value *= rupes_to_usd
            return round(numeric_value, 2)
        
        except ValueError:
            print(f"Could not conver price / rating: {value}")
            return None
        
    def clean_percentage_data(value):

        if pd.isna(value):
            return None
        
        clean_value = str(value).replace('%','').strip()

        try:
            return float(clean_value)
        except ValueError:
            print(f"Could not convert percentage: {value}")
            return None
        
    if 'discounted_price' in df.columns:
        df['discounted_price'] = df['discounted_price'].apply(lambda x: clean_price_rating_data(x, convert_to_usd=True))
    if 'actual_price' in df.columns:
        df['actual_price'] = df['actual_price'].apply(lambda x: clean_price_rating_data(x, convert_to_usd= True))
    if 'rating_count' in df.columns:
        df['rating_count'] = df['rating_count'].apply(clean_price_rating_data)

    if 'discount_percentage' in df.columns:
        df['discount_percentage'] = df['discount_percentage'].apply(clean_percentage_data)

    df.to_csv(filename, index=False)
    print(f"Columns cleaned and saved to: {filename}")

def check_data_integrity():

    print("\nStep 4: Checking data integrity...")

    products_df = pd.read_csv('cleaned_products.csv')
    reviews_df = pd.read_csv('cleaned_reviews.csv')

    print(f"Products: {len(products_df)} rows")
    print(f"reviews: {len(reviews_df)} rows")

    product_ids_in_products = set(products_df['product_id'].unique())
    product_ids_in_review = set(reviews_df['product_id'].unique())

    orphaned_reviews = product_ids_in_review - product_ids_in_products
    print(f"Oprphaned reviews (no matcing product): {len(orphaned_reviews)}")

    if len(orphaned_reviews) > 0:
        print("Sample orphaned product IDs:", list(orphaned_reviews)[:5])


# =============================================================================
# MYSQL INTEGRATION FUNCTIONS
# =============================================================================

def connect_to_mysql():
    """
    Connect to MySQL database
    Update the mysql_config dictionary with your database credentials
    """
    mysql_config = {
        'host': 'localhost',
        'user': 'root',
        'password': 'pass1234@',  # Update with your password
        'database': 'amazonSales'  # Update with your database name
    }
    
    try:
        connection = mysql.connector.connect(**mysql_config)
        if connection.is_connected():
            print("Successfully connected to MySQL database")
            return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None
    

def get_mysql_product_ids(connection):
    """
    Get all product IDs that successfully imported into MySQL
    Used to identify which reviews can be safely imported
    """
    try:
        cursor = connection.cursor()
        cursor.execute("SELECT product_id FROM products")
        results = cursor.fetchall()
        product_ids = [row[0] for row in results]
        cursor.close()
        return set(product_ids)
    except Error as e:
        print(f"Error fetching product IDs: {e}")
        return set()
    

def create_mysql_compatible_reviews():
    """
    Step 5: Create a reviews file compatible with MySQL foreign key constraints
    Only includes reviews for products that actually exist in the MySQL database
    """
    print("\nStep 5: Creating MySQL-compatible reviews file...")
    
    # Connect to MySQL
    connection = connect_to_mysql()
    if not connection:
        print("Failed to connect to MySQL. Please check your connection settings.")
        return
    
    try:
        # Get product IDs that actually exist in MySQL
        mysql_product_ids = get_mysql_product_ids(connection)
        print(f"Products found in MySQL: {len(mysql_product_ids)}")
        
        # Load reviews file
        reviews_df = pd.read_csv('cleaned_reviews.csv')
        print(f"Original reviews: {len(reviews_df)}")
        
        # Filter reviews to only include existing products
        valid_reviews = reviews_df[reviews_df['product_id'].isin(mysql_product_ids)]
        
        # Show statistics
        print(f"Valid reviews (matching MySQL products): {len(valid_reviews)}")
        print(f"Reviews to be excluded: {len(reviews_df) - len(valid_reviews)}")
        
        # Identify problematic product IDs
        review_product_ids = set(reviews_df['product_id'].unique())
        missing_product_ids = review_product_ids - mysql_product_ids
        
        if missing_product_ids:
            print(f"Product IDs in reviews but not in MySQL: {len(missing_product_ids)}")
            print("Sample missing IDs:", list(missing_product_ids)[:10])
        
        # Save MySQL-compatible reviews file
        output_file = 'reviews_for_mysql_import.csv'
        valid_reviews.to_csv(output_file, index=False)
        print(f"MySQL-compatible reviews saved as: {output_file}")
        
        # Show MySQL database statistics
        cursor = connection.cursor()
        cursor.execute("SELECT COUNT(*) FROM products")
        count = cursor.fetchone()[0]
        print(f"Total products in MySQL database: {count}")
        cursor.close()
        
    except Exception as e:
        print(f"Error processing data: {e}")
    
    finally:
        # Close MySQL connection
        if connection.is_connected():
            connection.close()
            print("MySQL connection closed")


# =============================================================================
# MAIN EXECUTION PIPELINE
# =============================================================================

def main():
    """
    Complete data processing pipeline for Amazon sales data
    Execute all steps in the correct order
    """
    print("=== AMAZON SALES DATA PROCESSING PIPELINE ===\n")
    
    # Step 1: Split raw data into normalized tables
    split_data_into_tables()
    
    # Step 2: Clean special characters from each table
    clean_special_characters('products.csv')
    clean_special_characters('users.csv') 
    clean_special_characters('reviews.csv')
    
    # Step 3: Clean numeric columns in products table
    clean_numeric_columns('cleaned_products.csv')
    
    # Step 4: Check data integrity
    check_data_integrity()
    
    # Step 5: Create MySQL-compatible reviews file
    # (Run this after importing products and users into MySQL)
    print("\n" + "="*50)
    print("IMPORTANT: Before running Step 5:")
    print("1. Import 'cleaned_products.csv' into MySQL")
    print("2. Import 'cleaned_users.csv' into MySQL") 
    print("3. Then run Step 5 to create compatible reviews file")
    print("="*50)
    
    # Uncomment the line below after importing products and users to MySQL
    create_mysql_compatible_reviews()


if __name__ == "__main__":
    main()
