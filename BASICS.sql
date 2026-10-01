CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY ,
    name VARCHAR(50) NOT NULL ,
    email VARCHAR(30) NOT NULL UNIQUE 
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY ;
    product_name VARCHAR(100) NOT NULL ,
    price NUMERIC(10,2) check(price > 0),
    stock_quantity INT check(stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id SERIAL primary key ,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE ,
    order_date date DEFAULT CURRENT_DATE , 
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders (order_id) ON DELETE CASCADE ,
    product_id INT REFERENCES products(product_id) ON DELETE RESTRICT ,
    quantity INT CHECK (quantity > 0 )
);

ALTER TABLE orders ADD COLUMN status VARCHAR(40) DEFAULT 'completed' ;

INSERT INTO customers (name,email) VALUES 
('Alice Smith', 'alice@example.com'),
('Bob Jones', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');

INSERT INTO products (product_name,price,stock_quantity) VALUES
('Laptop', 1200.00, 10),
('mouse', 443.10, 3),
('PC', 1300006.77, 22),
('monitor', 700000.30, 2);

INSERT INTO orders (customer_id, order_date) VALUES 
(1, '2026-03-01'),
(1, '2026-03-05'),
(2, '2026-03-10');

INSERT INTO order_items (order_id, product_id, quantity) VALUES 
(1,1,5),
(1,3,2),
(1,4,1),
(3,2,4);

UPDATE products 
SET stock_quantity = stock_quantity - 1 
WHERE product_id = 1

DELETE FROM customers WHERE email = 'bob@example.com' ;

SELECT c.name AS customer_name ,
       COUNT(DISTINCT o.order_id) AS total_orders ,
       SUM(oi.quantity * p.price) AS total_spent ,
       AVG(oi.quantity * p.price) AS avg_item_spend ,
       MIN(p.price) AS cheapest_item_bought ,
       MAX(p.price) AS most_expensive_item_bought 

FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id 
WHERE o.status = 'completed' 
GROUP BY c.customer_id, c.name 
HAVING SUM(oi.quantity * p.price) > 100 
ORDER BY total_spent DESC ;

   