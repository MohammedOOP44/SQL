CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL ,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY ,
    product_name VARCHAR(90) NOT NULL ,
    price NUMERIC(10,2) CHECK(price > 0),
    stock_quantity INT CHECK(stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY ,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE ,
    order_date DATE DEFAULT CURRENT_DATE 
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY ,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE ,
    product_id INT REFERENCES products(product_id) ON DELETE RESTRICT ,
    quantity INT CHECK(quantity > 0)
);

ALTER TABLE orders ADD COLUMN status VARCHAR(44) DEFAULT 'COMPLETED' ;

INSERT INTO customers (name, email) VALUES 
('hassan', 'hassan@gmail.com'),
('Bob Jones', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');

INSERT INTO products (product_name, price, stock_quantity) VALUES 
('Laptop', 1200.00, 10),
('mouse', 443.10, 3),
('PC', 1300006.77, 22),
('monitor', 700000.30, 2);

INSERT INTO orders (customer_id, order_date) VALUES 
(1),
(1, '2026-03-05'),
(2, '2026-03-10');

INSERT INTO order_items (order_id, product_id, quantity) VALUES 
(1,1,5),
(1,3,2),
(1,4,1),
(3,2,4);

UPDATE products p
SET stock_quantity = p.stock_quantity - oi.quantity 
FROM order_items oi 
WHERE p.product_id = oi.product_id 
AND oi.order_id = 1 
AND p.stock_quantity >= oi.quantity ;

DELETE FROM customers WHERE email = 'hassan@gmail.com' ;

SELECT c.name AS customer_name ,
       COUNT(DISTINCT o.order_id) AS total_orders ,
       SUM(io.quantity * p.price) AS total_spent ,
       AVG(io.quantity * p.price) AS avg_item_spent ,
       MIN(p.price) AS cheapest_item_bought ,
       MAX(p.price) AS most_expensive_item_bought ;

FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items io ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'COMPLETED'
""" Put all rows belonging to the same customer into one group """
GROUP BY c.customer_id , c.name
""" After grouping the customers, only keep customers whose total spending is greater than 100. """ 
HAVING SUM(oi.quantity * p.price) > 100
ORDER BY total_spent DESC ;