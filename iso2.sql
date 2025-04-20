-- =============================================
-- CODE FOR CONNECTION 2
-- =============================================
-- Run this in the second database connection window while connection 1 is still in transaction:

-- Set the same isolation level as connection 1
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Start transaction
START TRANSACTION;

-- Check product data (depending on isolation level, may or may not see connection 1's updates)
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

-- Try to update the same row (may block depending on isolation level)
UPDATE products SET stock_quantity = stock_quantity - 2 WHERE product_id = 1;

-- Check data after update
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

COMMIT;