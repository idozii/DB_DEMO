USE transaction_demo;

-- 1. Test money transfer procedure
-- First, let's check balances before the transfer
SELECT account_id, account_name, balance FROM accounts 
WHERE account_id IN ('A1001', 'A1002');

-- Execute transfer (success case)
SET @success = FALSE;
CALL transfer_money('A1001', 'A1002', 500.00, @success);
SELECT @success AS 'Transfer Successful';

-- Check balances after transfer
SELECT account_id, account_name, balance FROM accounts 
WHERE account_id IN ('A1001', 'A1002');

-- Execute transfer (fail case - insufficient funds)
SET @success = FALSE;
CALL transfer_money('A1003', 'A1004', 1000.00, @success);
SELECT @success AS 'Transfer Successful';

-- Check balances to confirm no change in failed transfer
SELECT account_id, account_name, balance FROM accounts 
WHERE account_id IN ('A1003', 'A1004');

-- 2. Test order creation and item addition
-- Create a new order
SET @success = FALSE;
SET @order_id = NULL;
CALL create_order(1, @order_id, @success);
SELECT @success AS 'Order Created', @order_id AS 'New Order ID';

-- Add items to the order (success case)
SET @success = FALSE;
CALL add_item_to_order(@order_id, 1, 2, @success);  -- 2 laptops
SELECT @success AS 'Item Added';

SET @success = FALSE;
CALL add_item_to_order(@order_id, 3, 5, @success);  -- 5 headphones
SELECT @success AS 'Item Added';

-- Check order total
SELECT o.order_id, c.customer_name, o.total_amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_id = @order_id;

-- Check order items
SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price, (oi.quantity * oi.unit_price) AS 'Line Total'
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = @order_id;

-- Check updated product stock
SELECT p.product_id, p.product_name, p.stock_quantity
FROM products p
WHERE p.product_id IN (1, 3);

-- Add item (fail case - insufficient stock)
SET @success = FALSE;
CALL add_item_to_order(@order_id, 5, 25, @success);  -- 25 monitors (only 20 in stock)
SELECT @success AS 'Item Added';

-- Check monitor stock is unchanged
SELECT product_id, product_name, stock_quantity
FROM products WHERE product_id = 5;

-- 3. Test transaction logs
SELECT * FROM transaction_log ORDER BY log_id DESC LIMIT 10;

-- 4. Test lock demo
-- To demonstrate locking, you would run this in one session:
-- START TRANSACTION;
-- SELECT * FROM lock_demo WHERE id = 1 FOR UPDATE;
-- -- Wait 10 seconds to simulate processing
-- UPDATE lock_demo SET value = 'Updated in Session 1', last_updated = CURRENT_TIMESTAMP WHERE id = 1;
-- COMMIT;

-- And this in another session while the first transaction is running:
-- START TRANSACTION;
-- SELECT * FROM lock_demo WHERE id = 1 FOR UPDATE;
-- UPDATE lock_demo SET value = 'Updated in Session 2', last_updated = CURRENT_TIMESTAMP WHERE id = 1;
-- COMMIT;

-- For recoverability (successful case)
CALL demo_recovery(FALSE);
SELECT * FROM transaction_log WHERE transaction_type = 'RECOVERY';

-- For recoverability (failure case)
CALL demo_recovery(TRUE);
SELECT * FROM transaction_log WHERE transaction_type = 'RECOVERY';

-- For consistency
CALL demo_consistency();
SELECT * FROM transaction_log WHERE transaction_type = 'CONSISTENCY';

-- For isolation levels (set up for dirty read test)
CALL test_dirty_read();
-- Then in another session:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM isolation_demo;