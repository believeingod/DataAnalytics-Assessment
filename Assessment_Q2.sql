USE `adashi_staging`;
/*  Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)
*/

WITH MonthlyTransactions AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
        owner_id,
        COUNT(*) AS num_transactions
    FROM savings_savingsaccount
    GROUP BY transaction_month, owner_id
),
CustomerMonthlyAvg AS (
    SELECT
        owner_id,
        SUM(num_transactions) / COUNT(DISTINCT transaction_month) AS avg_transactions_per_month
    FROM MonthlyTransactions
    GROUP BY owner_id
)
SELECT
    CASE
        WHEN cma.avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN cma.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(DISTINCT cma.owner_id) AS customer_count,
    AVG(cma.avg_transactions_per_month) AS avg_transactions_per_month
FROM CustomerMonthlyAvg cma
GROUP BY frequency_category
ORDER BY
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
