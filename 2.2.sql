-- 1. Install the required extension if not already installed
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2. Create a foreign server to connect to the OLTP database
CREATE SERVER oltp_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'localhost', dbname 'DIY_Electronics_Kits', port '5432');

-- 3. Create a user mapping for the current user
CREATE USER MAPPING FOR CURRENT_USER
    SERVER oltp_server
    OPTIONS (user 'postgres', password 'your_password');

-- 4. Import tables from the OLTP database into the current schema
IMPORT FOREIGN SCHEMA public
FROM SERVER oltp_server
INTO public;

-- 5. Create a function to transfer data
CREATE OR REPLACE FUNCTION transferring_data()
RETURNS void AS $$
BEGIN
    -- 6. Transferring Users data to DimUsers
    INSERT INTO DimUsers (user_id, username, email, password, created_at, updated_at)
    SELECT u.user_id, u.username, u.email, u.password, u.created_at, u.updated_at
    FROM public.Users u
    LEFT JOIN DimUsers du ON u.user_id = du.user_id
    WHERE du.user_id IS NULL;

    -- 7. Transferring Profiles data to DimUserProfiles
    INSERT INTO DimUserProfiles (profile_id, user_id, first_name, last_name, phone_number, address)
    SELECT up.profile_id, up.user_id, up.first_name, up.last_name, up.phone_number, up.address
    FROM public.UserProfiles up
    LEFT JOIN DimUserProfiles dup ON up.profile_id = dup.profile_id
    WHERE dup.profile_id IS NULL;

    -- 8. Transferring Categories data to DimCategories
    INSERT INTO DimCategories (category_id, name, description)
    SELECT c.category_id, c.name, c.description
    FROM public.Categories c
    LEFT JOIN DimCategories dc ON c.category_id = dc.category_id
    WHERE dc.category_id IS NULL;

    -- 9. Transferring Products data to DimProducts
    INSERT INTO DimProducts (product_id, name, description, price, stock_quantity, category_id, created_at, updated_at)
    SELECT p.product_id, p.name, p.description, p.price, p.stock_quantity, p.category_id, p.created_at, p.updated_at
    FROM public.Products p
    LEFT JOIN DimProducts dp ON p.product_id = dp.product_id
    WHERE dp.product_id IS NULL;

    -- 10. Transferring Orders data to DimOrders
    INSERT INTO DimOrders (order_id, user_id, order_date, status, total_amount, delivery_address, payment_method)
    SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.delivery_address, o.payment_method
    FROM public.Orders o
    LEFT JOIN DimOrders dimo ON o.order_id = dimo.order_id
    WHERE dimo.order_id IS NULL;

    -- 11. Transferring OrderDetails data to DimOrderDetails
    INSERT INTO DimOrderDetails (order_detail_id, order_id, product_id, quantity, price)
    SELECT od.order_detail_id, od.order_id, od.product_id, od.quantity, od.price
    FROM public.OrderDetails od
    LEFT JOIN DimOrderDetails dod ON od.order_detail_id = dod.order_detail_id
    WHERE dod.order_detail_id IS NULL;

    -- 12. Transferring Suppliers data to DimSuppliers
    INSERT INTO DimSuppliers (supplier_id, name, contact_name, phone_number, email, address)
    SELECT s.supplier_id, s.name, s.contact_name, s.phone_number, s.email, s.address
    FROM public.Suppliers s
    LEFT JOIN DimSuppliers ds ON s.supplier_id = ds.supplier_id
    WHERE ds.supplier_id IS NULL;

    -- 13. Transferring ProductSuppliers data to DimProductSuppliers
    INSERT INTO DimProductSuppliers (product_supplier_id, product_id, supplier_id, supply_price, supply_date)
    SELECT ps.product_supplier_id, ps.product_id, ps.supplier_id, ps.supply_price, ps.supply_date
    FROM public.ProductSuppliers ps
    LEFT JOIN DimProductSuppliers dps ON ps.product_supplier_id = dps.product_supplier_id
    WHERE dps.product_supplier_id IS NULL;

    -- 14. Transferring Reviews data to DimReviews
    INSERT INTO DimReviews (review_id, product_id, user_id, rating, comment, review_date)
    SELECT r.review_id, r.product_id, r.user_id, r.rating, r.comment, r.review_date
    FROM public.Reviews r
    LEFT JOIN DimReviews dr ON r.review_id = dr.review_id
    WHERE dr.review_id IS NULL;

    -- 15. Transferring Wishlists data to DimWishlists
    INSERT INTO DimWishlists (wishlist_id, user_id, created_at)
    SELECT w.wishlist_id, w.user_id, w.created_at
    FROM public.Wishlists w
    LEFT JOIN DimWishlists dw ON w.wishlist_id = dw.wishlist_id
    WHERE dw.wishlist_id IS NULL;

    -- 16. Transferring WishlistItems data to DimWishlistItems
    INSERT INTO DimWishlistItems (wishlist_item_id, wishlist_id, product_id)
    SELECT wi.wishlist_item_id, wi.wishlist_id, wi.product_id
    FROM public.WishlistItems wi
    LEFT JOIN DimWishlistItems dwi ON wi.wishlist_item_id = dwi.wishlist_item_id
    WHERE dwi.wishlist_item_id IS NULL;

    -- 17. Transferring Roles data to DimRoles
    INSERT INTO DimRoles (role_id, role_name)
    SELECT r.role_id, r.role_name
    FROM public.Roles r
    LEFT JOIN DimRoles dr ON r.role_id = dr.role_id
    WHERE dr.role_id IS NULL;

    -- 18. Transferring UserRoles data to DimUserRoles
    INSERT INTO DimUserRoles (user_role_id, user_id, role_id)
    SELECT ur.user_role_id, ur.user_id, ur.role_id
    FROM public.UserRoles ur
    LEFT JOIN DimUserRoles dur ON ur.user_role_id = dur.user_role_id
    WHERE dur.user_role_id IS NULL;

    -- 19. Transferring data to FactOrders
    INSERT INTO FactOrders (order_id, user_id, order_date_id, status, total_amount, delivery_address, payment_method)
    SELECT
        o.order_id,
        o.user_id,
        d.date_id,
        o.status,
        o.total_amount,
        o.delivery_address,
        o.payment_method
    FROM
        public.Orders o
    JOIN DimDate d ON DATE(o.order_date) = d.date
    LEFT JOIN FactOrders fo ON o.order_id = fo.order_id
    WHERE fo.order_id IS NULL;

    -- 20. Transferring data to FactReviews
    INSERT INTO FactReviews (review_id, product_id, user_id, rating, comment, review_date_id)
    SELECT
        r.review_id,
        r.product_id,
        r.user_id,
        r.rating,
        r.comment,
        d.date_id
    FROM
        public.Reviews r
    JOIN DimDate d ON DATE(r.review_date) = d.date
    LEFT JOIN FactReviews fr ON r.review_id = fr.review_id
    WHERE fr.review_id IS NULL;

END;
$$ LANGUAGE plpgsql;

-- 21. Call the function to transfer data
SELECT transferring_data();

-- Example queries to verify data transfer
SELECT * FROM DimUsers;
SELECT * FROM FactOrders;


-- Select statements for all tables
-- DimUsers
SELECT * FROM DimUsers;
-- DimUserProfiles
SELECT * FROM DimUserProfiles;
-- DimCategories
SELECT * FROM DimCategories;
-- DimProducts
SELECT * FROM DimProducts;
-- DimOrders
SELECT * FROM DimOrders;
-- DimOrderDetails
SELECT * FROM DimOrderDetails;
-- DimSuppliers
SELECT * FROM DimSuppliers;
-- DimProductSuppliers
SELECT * FROM DimProductSuppliers;
-- DimReviews
SELECT * FROM DimReviews;
-- DimWishlists
SELECT * FROM DimWishlists;
-- DimWishlistItems
SELECT * FROM DimWishlistItems;
-- DimRoles
SELECT * FROM DimRoles;
-- DimUserRoles
SELECT * FROM DimUserRoles;
-- DimDate
SELECT * FROM DimDate;
-- FactOrders
SELECT * FROM FactOrders;
-- FactReviews
SELECT * FROM FactReviews;