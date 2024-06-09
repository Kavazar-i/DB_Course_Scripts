-- Создание базы данных Dim_DIY_Electronics_Kits
-- CREATE DATABASE Dim_DIY_Electronics_Kits;

-- Использование созданной базы данных
-- \c `dim_DIY_Electronics_Kits;

-- Таблица Пользователи
CREATE TABLE DimUsers (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица Профили пользователей
CREATE TABLE DimUserProfiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone_number VARCHAR(22),
    address VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE
);

-- Таблица Категории
CREATE TABLE DimCategories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Таблица Товары
CREATE TABLE DimProducts (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES DimCategories(category_id) ON DELETE SET NULL
);

-- Таблица Заказы
CREATE TABLE DimOrders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE
);

-- Таблица Детали заказов
CREATE TABLE DimOrderDetails (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES DimOrders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES DimProducts(product_id) ON DELETE CASCADE
);

-- Таблица Поставщики
CREATE TABLE DimSuppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(255)
);

-- Таблица Поставщики товаров
CREATE TABLE DimProductSuppliers (
    product_supplier_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,
    supply_price DECIMAL(10, 2),
    supply_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES DimProducts(product_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES DimSuppliers(supplier_id) ON DELETE CASCADE
);

-- Таблица Отзывы
CREATE TABLE DimReviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES DimProducts(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE
);

-- Таблица Списки желаемого
CREATE TABLE DimWishlists (
    wishlist_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE
);

-- Таблица Элементы списков желаемого
CREATE TABLE DimWishlistItems (
    wishlist_item_id SERIAL PRIMARY KEY,
    wishlist_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (wishlist_id) REFERENCES DimWishlists(wishlist_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES DimProducts(product_id) ON DELETE CASCADE
);

-- Таблица Ролей
CREATE TABLE DimRoles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица пользователей с ролями
CREATE TABLE DimUserRoles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES DimRoles(role_id) ON DELETE CASCADE
);

-- Add necessary constraints
ALTER TABLE DimOrders ADD CONSTRAINT dim_unique_user_order UNIQUE (user_id, order_date);
ALTER TABLE DimOrderDetails ADD CONSTRAINT dim_unique_order_product UNIQUE (order_id, product_id);
ALTER TABLE DimWishlists ADD CONSTRAINT dim_unique_user_wishlist UNIQUE (user_id);
ALTER TABLE DimWishlistItems ADD CONSTRAINT dim_unique_wishlist_product UNIQUE (wishlist_id, product_id);


CREATE TABLE DimDate (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    day INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    week_of_year INT NOT NULL
);

CREATE TABLE FactOrders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount INT NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id),
    FOREIGN KEY (order_date_id) REFERENCES DimDate(date_id)
);

CREATE TABLE FactReviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES DimProducts(product_id),
    FOREIGN KEY (user_id) REFERENCES DimUsers(user_id),
    FOREIGN KEY (review_date_id) REFERENCES DimDate(date_id)
);





-- Drop existing primary key constraint
ALTER TABLE DimUsers DROP CONSTRAINT DimUsers_pkey CASCADE;

-- Recreate foreign key constraints
ALTER TABLE DimUsers ADD CONSTRAINT DimUsers_user_id_unique UNIQUE (user_id);

ALTER TABLE DimUserProfiles
ADD CONSTRAINT dimuserprofiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;
ALTER TABLE DimOrders
ADD CONSTRAINT dimorders_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;
ALTER TABLE DimReviews
ADD CONSTRAINT dimreviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;
ALTER TABLE DimWishlists
ADD CONSTRAINT dimwishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;
ALTER TABLE DimUserRoles
ADD CONSTRAINT dimuserroles_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;
ALTER TABLE FactOrders
ADD CONSTRAINT factorders_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;
ALTER TABLE FactReviews
ADD CONSTRAINT factreviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES DimUsers(user_id) ON DELETE CASCADE;


-- Add new columns for SCD Type 2
ALTER TABLE DimUsers
ADD COLUMN user_history_id SERIAL PRIMARY KEY,
ADD COLUMN start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN end_date TIMESTAMP DEFAULT '9999-12-31',
ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- Create trigger function for SCD Type 2
CREATE OR REPLACE FUNCTION scd_type_2_trigger() RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.username IS DISTINCT FROM NEW.username) OR
       (OLD.email IS DISTINCT FROM NEW.email) OR
       (OLD.password IS DISTINCT FROM NEW.password) THEN
        -- Set the old record as no longer current
        UPDATE DimUsers
        SET end_date = CURRENT_TIMESTAMP,
            is_current = FALSE
        WHERE user_id = OLD.user_id AND is_current = TRUE;

        -- Insert the new record
        INSERT INTO DimUsers (user_id, username, email, password, start_date)
        VALUES (OLD.user_id, NEW.username, NEW.email, NEW.password, CURRENT_TIMESTAMP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER scd_type_2_update
BEFORE UPDATE ON DimUsers
FOR EACH ROW
EXECUTE FUNCTION scd_type_2_trigger();
