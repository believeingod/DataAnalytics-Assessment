USE `adashi_staging`; 

/*  For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest
*/

WITH MonthlyTransactions AS (
    SELECT
        sa.owner_id AS customer_id,
        TIMESTAMPDIFF(MONTH, MIN(DATE(sa.transaction_date)), MAX(DATE(sa.transaction_date))) + 1 AS tenure_months,
        COUNT(sa.id) AS total_transactions
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),
UserTenure AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(
            MONTH,
            DATE(u.created_on),
			CURRENT_DATE
        ) + 1 AS tenure_months_signup
    FROM users_customuser u
    GROUP BY u.id, u.name, u.date_joined
)
SELECT
    ut.customer_id,
    ut.name,
    COALESCE(mt.tenure_months, ut.tenure_months_signup, 1) AS tenure_months,
    COALESCE(mt.total_transactions, 0) AS total_transactions,
    CAST(
        COALESCE(
            (CAST(mt.total_transactions AS DECIMAL(10,2)) / COALESCE(mt.tenure_months, ut.tenure_months_signup, 1)) * 12 * 0.1,
            0
        ) AS DECIMAL(10,2)
    ) AS estimated_clv
FROM UserTenure ut
LEFT JOIN MonthlyTransactions mt ON ut.customer_id = mt.customer_id
ORDER BY estimated_clv DESC;
