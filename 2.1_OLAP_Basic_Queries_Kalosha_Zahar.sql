-- Total sales by month
SELECT
    d.year, d.month, SUM(f.total_amount) AS total_sales
FROM
    FactOrders f
JOIN
    DimDate d ON f.order_date_id = d.date_id
GROUP BY
    d.year, d.month
ORDER BY
    d.year, d.month;

-- Average rating of products by category
SELECT
    c.name AS category, AVG(r.rating) AS average_rating
FROM
    FactReviews r
JOIN
    DimProducts p ON r.product_id = p.product_id
JOIN
    DimCategories c ON p.category_id = c.category_id
GROUP BY
    c.name
ORDER BY
    average_rating DESC;
