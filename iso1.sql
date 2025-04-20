
USE transaction_demo;

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Start transaction
START TRANSACTION;

-- Display initial product data
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

-- Update the product stock
UPDATE products SET stock_quantity = stock_quantity - 5 WHERE product_id = 1;

-- Check the updated product data (visible to this transaction)
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

-- This will make the script pause for 30 seconds to give you time to run iso2.sql
SELECT SLEEP(30) AS 'Waiting - Run iso2.sql now in another connection window';

-- Now manually commit
COMMIT;

-- Verify final state
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;