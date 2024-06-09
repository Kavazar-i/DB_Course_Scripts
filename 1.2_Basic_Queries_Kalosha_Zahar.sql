-- Поиск товаров по категории
SELECT p.product_id, p.name, p.description, p.price, p.stock_quantity, c.name as category
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.name ILIKE '%electronics%';

-- Просмотр деталей товара
SELECT p.product_id, p.name, p.description, p.price, p.stock_quantity, c.name as category
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.product_id = 1;



-- Добавление товара в корзину (таблица OrderDetails для текущего заказа)
INSERT INTO OrderDetails (order_id, product_id, quantity, price)
VALUES (1, 1, 2, (SELECT price FROM Products WHERE product_id = 1));

-- Удаление товара из корзины
DELETE FROM OrderDetails
WHERE order_id = 1 AND product_id = 1;

-- Изменение количества товара в корзине
UPDATE OrderDetails
SET quantity = 3
WHERE order_id = 1 AND product_id = 1;

-- Просмотр товаров в корзине и общей стоимости
SELECT od.product_id, p.name, od.quantity, od.price, (od.quantity * od.price) as total_price
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
WHERE od.order_id = 1;



-- Просмотр деталей заказа
SELECT o.order_id, u.username, o.delivery_address, o.order_date, o.status, o.payment_method, od.product_id, p.name, od.quantity, od.price
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
WHERE o.order_id = 1;



-- Просмотр данных пользователя и его заказов
SELECT u.username, u.email, u.created_at, o.order_id, o.order_date, o.status, o.total_amount
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
WHERE u.user_id = 1;

-- Просмотр списка понравившихся товаров пользователя
SELECT w.wishlist_id, wi.product_id, p.name, p.price
FROM Wishlists w
JOIN WishlistItems wi ON w.wishlist_id = wi.wishlist_id
JOIN Products p ON wi.product_id = p.product_id
WHERE w.user_id = 1;



-- Действия администратора
-- Добавление новой категории
INSERT INTO Categories (name, description) VALUES ('New Category', 'Description of new category');

-- Добавление нового товара
INSERT INTO Products (name, description, price, stock_quantity, category_id)
VALUES ('New Product', 'Description of new product', 100.00, 10, 1);

-- Обновление статуса заказа
UPDATE Orders SET status = 'Shipped' WHERE order_id = 1;

-- Обновление доступности товара
UPDATE Products SET stock_quantity = 5 WHERE product_id = 1;

-- Просмотр всех заказов
SELECT * FROM Orders;
