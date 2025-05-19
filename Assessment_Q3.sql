USE `adashi_staging`; 

/* Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .*/
SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE
        WHEN p.is_a_fund = 1 THEN 'Savings'
        WHEN p.is_regular_savings = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(sa.transaction_date)) AS inactivity_days
FROM
    plans_plan p
LEFT JOIN
    savings_savingsaccount sa ON p.id = sa.plan_id
WHERE
    p.is_deleted != 1 AND
    (p.is_a_fund = 1 OR p.is_regular_savings = 1)
GROUP BY
    p.id, p.owner_id, p.is_a_fund, p.is_regular_savings
HAVING
    MAX(sa.transaction_date) < CURDATE() - INTERVAL 365 DAY OR MAX(sa.transaction_date) IS NULL;