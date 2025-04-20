-- Active: 1745157292002@@127.0.0.1@3306
USE transaction_demo;
-- CODE FOR CONNECTION 1
-- =============================================
-- Run this in the first database connection window:

-- Set transaction isolation level
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- You can try different levels: READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE

-- Start transaction
START TRANSACTION;

-- Display initial product data
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

-- Update the product stock
UPDATE products SET stock_quantity = stock_quantity - 5 WHERE product_id = 1;

-- Check the updated product data (visible to this transaction)
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

-- Wait for 20 seconds before committing (to observe isolation)

-- Don't commit yet (do this manually after checking connection 2)
COMMIT;