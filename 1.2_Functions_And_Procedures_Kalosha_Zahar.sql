-- Функция для добавления товара в корзину:
CREATE OR REPLACE FUNCTION add_to_cart(order_id INT, product_id INT, quantity INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO OrderDetails (order_id, product_id, quantity, price)
    VALUES (order_id, product_id, quantity, (SELECT price FROM Products WHERE product_id = product_id));
END;
$$ LANGUAGE plpgsql;


-- Функция для удаления товара из корзины:
CREATE OR REPLACE FUNCTION remove_from_cart(order_id INT, product_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM OrderDetails WHERE order_id = order_id AND product_id = product_id;
END;
$$ LANGUAGE plpgsql;

-- Функция для изменения количества товара в корзине:
CREATE OR REPLACE FUNCTION update_cart_quantity(order_id INT, product_id INT, quantity INT)
RETURNS VOID AS $$
BEGIN
    UPDATE OrderDetails SET quantity = quantity WHERE order_id = order_id AND product_id = product_id;
END;
$$ LANGUAGE plpgsql;
