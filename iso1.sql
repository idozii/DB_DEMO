
USE transaction_demo;

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

-- Display initial product data
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 2;

-- Update the product stock
UPDATE products SET stock_quantity = stock_quantity - 5 WHERE product_id = 2;

-- Check the updated product data (visible to this transaction)
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 2;

SELECT SLEEP(20) AS 'Waiting - Run iso2.sql now in another connection window';

COMMIT;

-- Verify final state
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;