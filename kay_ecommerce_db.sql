use kay_ecommerce_db

create table customers(
customer_id int auto_increment primary key,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100) not null unique,
phone_num varchar(20) unique,
reg_date date not null
);

create table products(
product_id int auto_increment primary key,
product_name varchar(100) not null unique,
category varchar(50),
price decimal(10, 2) not null,
stock_quantity int not null,
constraint check_positive_price check (price >= 0.00),
constraint check_positive_stock check (stock_quantity >= 0)
);

create table orders(
order_id int auto_increment primary key,
customer_id int,
order_data timestamp default current_timestamp,
total_amount decimal(10,2) not null,
order_status enum("pending"),
foreign key (customer_id) references customers(customer_id) on delete set null
);

create table order_items(
order_item_id int auto_increment primary key,
order_id int not null,
product_id int not null,
quantity int not null,
price_at_purchase decimal(10,2) not null,
foreign key (order_id) references orders(order_id)on delete cascade,
foreign key (product_id) references products(product_id) on delete cascade,
constraint check_positive_quantity check (quantity > 0)
);

create table payments(
payment_id int auto_increment primary key,
order_id int not null unique,
payment_date timestamp default current_timestamp,
payment_method varchar(50) not null,
payment_status enum('completed','failed','refunded')default'completed',
foreign key (order_id) references orders (order_id)on delete cascade 
);


insert into customers(first_name, last_name, email, phone_num, reg_date) values
('Micheal','Scott','m.scott@hotmail.com','+49017585269', '2026-03-12'),
('Paul','Smith','p.smith@hotmail.com','+49017345645', '2026-01-12'),
('Lisa','Baker','l.baker@hotmail.com','+49017234987', '2026-02-02'),
('Conner','Hummer','c.hummer@hotmail.com','+49017122808', '2026-02-10');

insert into products(product_name, category, price, stock_quantity) values
('Slim-Fit Denim Jeans', 'Apparel', 59.99, 120),
('Classic Leather Jacket', 'Outerwear', 189.50, 35),
('Running Sneakers', 'Footwear', 89.99, 75),
('Cotton Crewneck T-Shirt', 'Apparel', 24.99, 300);

INSERT INTO orders (customer_id, total_amount, order_status) VALUES 
(1, 378.98, 'Pending'),    
(2, 699.00, 'Pending'),
(3, 120.00, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES 
(1, 1, 1, 249.99), 
(1, 4, 10, 12.89), 
(2, 3, 2, 349.50), 
(3, 2, 1, 120.00);

INSERT INTO payments (order_id, payment_method, payment_status) VALUES 
(1, 'Credit Card', 'completed'),
(2, 'Bank Transfer', 'completed'),
(3, 'Credit Card', 'completed');


SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    oi.quantity,
    oi.price_at_purchase,
    (oi.quantity * oi.price_at_purchase) AS line_item_subtotal,
    o.order_status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id ASC;

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders_placed,
    SUM(o.total_amount) AS lifetime_expenditure
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING lifetime_expenditure > 200.00
ORDER BY lifetime_expenditure DESC;

INSERT INTO customers (first_name, last_name, email, phone_num, reg_date)values 
('Luka', 'Modric', 'luka.modric@gmail.com', '+491761456656', '2026-06-09');

SELECT product_name, category, price, stock_quantity
FROM products
WHERE stock_quantity < 40
ORDER BY stock_quantity ASC;

UPDATE products
SET price = 199.99, stock_quantity = 50
WHERE product_name = 'Classic Leather Jacket';

DELETE FROM orders
WHERE order_id = 3 AND order_status = 'Pending';

SELECT 
    p.category,
    COUNT(oi.order_item_id) AS total_units_sold,
    SUM(oi.quantity * oi.price_at_purchase) AS total_category_revenue
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_category_revenue DESC;

SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    oi.quantity,
    oi.price_at_purchase
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

