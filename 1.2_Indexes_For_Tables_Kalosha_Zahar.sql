-- Индексы для улучшения производительности поиска и соединений
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_orders_user ON Orders(user_id);
CREATE INDEX idx_orderdetails_order ON OrderDetails(order_id);
CREATE INDEX idx_orderdetails_product ON OrderDetails(product_id);
CREATE INDEX idx_reviews_product ON Reviews(product_id);
CREATE INDEX idx_reviews_user ON Reviews(user_id);
CREATE INDEX idx_wishlist_user ON Wishlists(user_id);
CREATE INDEX idx_wishlistitems_wishlist ON WishlistItems(wishlist_id);
CREATE INDEX idx_wishlistitems_product ON WishlistItems(product_id);
