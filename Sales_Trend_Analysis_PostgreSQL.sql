-- =========================================================
-- 🧠 Sales Trend Analysis Using Aggregations (PostgreSQL)
-- Objective: Analyze monthly revenue and order volume
-- =========================================================

-- 1️⃣ Create table
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    revenue NUMERIC(10,2) NOT NULL
);

-- 2️⃣ Insert sample data
INSERT INTO orders (order_date, revenue) VALUES
('2024-01-05', 120.00),
('2024-01-20', 80.00),
('2024-02-02', 150.00),
('2024-02-15', 200.00),
('2024-03-10', 50.00),
('2024-03-28', 300.00),
('2024-04-04', 220.00),
('2024-04-20', 180.00),
('2024-05-01', 400.00),
('2024-05-15', 100.00),
('2024-06-03', 250.00),
('2024-06-30', 100.00),
('2024-07-11', 500.00),
('2024-07-20', 60.00),
('2024-08-01', 90.00),
('2024-08-18', 110.00),
('2024-09-05', 130.00),
('2024-09-25', 170.00);

-- 3️⃣ Monthly Aggregations
WITH monthly AS (
    SELECT
        TO_CHAR(DATE_TRUNC('month', order_date), 'YYYY-MM') AS month,
        SUM(revenue) AS total_revenue,
        COUNT(*) AS order_count,
        AVG(revenue) AS avg_order_value
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    total_revenue,
    order_count,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(
        100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY month), 0)
    , 2) AS mom_revenue_growth_pct,
    SUM(total_revenue) OVER (ORDER BY month) AS cumulative_revenue,
    ROUND(AVG(total_revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3mo
FROM monthly
ORDER BY month;

-- =========================================================
-- End of Script
-- =========================================================
