
DROP DATABASE IF EXISTS transaction_demo;
CREATE DATABASE transaction_demo;
USE transaction_demo;

CREATE TABLE accounts (
    account_id VARCHAR(10) PRIMARY KEY,
    account_name VARCHAR(50) NOT NULL,
    balance DECIMAL(10,2) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT check_positive_balance CHECK (balance >= 0)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    CONSTRAINT check_positive_stock CHECK (stock_quantity >= 0)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE transaction_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_type VARCHAR(50) NOT NULL,
    entity_id VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id VARCHAR(50)
);

INSERT INTO accounts (account_id, account_name, balance) VALUES
('A1001', 'Alice Smith', 1000.00),
('A1002', 'Bob Johnson', 1500.00),
('A1003', 'Charlie Brown', 750.00),
('A1004', 'Diana Prince', 2500.00);

INSERT INTO products (product_name, price, stock_quantity) VALUES
('Laptop', 999.99, 25),
('Smartphone', 499.99, 50),
('Headphones', 99.99, 100),
('Tablet', 349.99, 30),
('Monitor', 249.99, 20);

INSERT INTO customers (customer_name, email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Mike Wilson', 'mike@example.com'),
('Sarah Brown', 'sarah@example.com');

DELIMITER //
CREATE PROCEDURE transfer_money(
    IN from_account VARCHAR(10),
    IN to_account VARCHAR(10),
    IN amount DECIMAL(10,2),
    OUT success BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET success = FALSE;
    END;
    
    START TRANSACTION;
    
    -- Check if accounts exist and have sufficient funds
    IF (SELECT balance FROM accounts WHERE account_id = from_account) >= amount THEN
        -- Deduct from source account
        UPDATE accounts SET balance = balance - amount WHERE account_id = from_account;
        
        -- Add to destination account
        UPDATE accounts SET balance = balance + amount WHERE account_id = to_account;
        
        -- Log the transaction
        INSERT INTO transaction_log (transaction_type, entity_id, old_value, new_value)
        VALUES ('TRANSFER', CONCAT(from_account, '->', to_account), amount, 'completed');
        
        COMMIT;
        SET success = TRUE;
    ELSE
        ROLLBACK;
        SET success = FALSE;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE create_order(
    IN p_customer_id INT,
    OUT p_order_id INT,
    OUT success BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET success = FALSE;
        SET p_order_id = NULL;
    END;
    
    START TRANSACTION;
    
    -- Create new order
    INSERT INTO orders (customer_id, status, total_amount)
    VALUES (p_customer_id, 'pending', 0);
    
    SET p_order_id = LAST_INSERT_ID();
    
    -- Log the transaction
    INSERT INTO transaction_log (transaction_type, entity_id, new_value)
    VALUES ('ORDER_CREATE', p_order_id, 'pending');
    
    COMMIT;
    SET success = TRUE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_item_to_order(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    OUT success BOOLEAN
)
BEGIN
    DECLARE product_price DECIMAL(10,2);
    DECLARE current_stock INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET success = FALSE;
    END;
    
    START TRANSACTION;
    
    -- Get product price and check stock with lock
    SELECT price, stock_quantity INTO product_price, current_stock
    FROM products WHERE product_id = p_product_id FOR UPDATE;
    
    IF current_stock >= p_quantity THEN
        -- Add order item
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, product_price);
        
        -- Update product stock
        UPDATE products 
        SET stock_quantity = stock_quantity - p_quantity 
        WHERE product_id = p_product_id;
        
        -- Update order total
        UPDATE orders 
        SET total_amount = total_amount + (product_price * p_quantity)
        WHERE order_id = p_order_id;
        
        -- Log the transaction
        INSERT INTO transaction_log (transaction_type, entity_id, old_value, new_value)
        VALUES ('ADD_ITEM', p_order_id, p_product_id, p_quantity);
        
        COMMIT;
        SET success = TRUE;
    ELSE
        ROLLBACK;
        SET success = FALSE;
    END IF;
END //
DELIMITER ;
