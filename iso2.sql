
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

-- Check product data (depending on isolation level, may or may not see connection 1's updates)
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 2;

-- Try to update the same row (may block depending on isolation level)
UPDATE products SET stock_quantity = stock_quantity - 2 WHERE product_id = 2;

-- Check data after update
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 2;

COMMIT;